---
title: Querying 50k Gameservers in 100 lines of Python
date: 2015-07-29
mast: sourcestats
aliases:
    - /posts/Querying_50k_Gameservers_in_100_lines_of_Python/
---

[A long while back](https://web.archive.org/web/20101121000430/http://sourceserverstats.com/) I built a built a web app which provided search and aggregated stats for Valve gameservers. At any time there are ~50k of these registered with the "master server", but only 20-40% of these are accessible publically. The original collector was written in PHP and would take about 20 minutes to discover and collect stats from the gameservers. I have rebuilt the collector in Python and it's able to collect all ~50k servers in under a minute, given a suitable (>=100mbit) connection.

In this post I'll outline how we can build such a collector. To do so we'll make use of two wonderful Python packages: [gevent](http://www.gevent.org/) allows us to fire off requests in parallel which is essential to achieve the speeds desired and [python-valve](https://github.com/Holiverh/python-valve) talks the Valve master and game server protocols. The two parts of the collecting process are **a)** read server addresses from the master server and **b)** read information directly from each server.

Querying the master server is as simple as:

    def find_servers():
        count = 0
        greenlets = []
        master = MasterServerQuerier(
            address=(MASTER_HOST, 27011), timeout=MASTER_TIMEOUT
        )

        try:
            for address in master.find():
                greenlets.append(pool.spawn(get_server_stats, address))
                count += 1

        except NoResponseError as e:
            # Protocol is UDP so there's no "end"
            if u'Timed out' not in e.message:
                logging.warning('Error querying master server: {0}'.format(e))

        finally:
            logging.info('Found {0} addresses'.format(count))
            return greenlets

Here we're reading server addresses as they come in and spawning a `get_server_stats` greenlet for each. We then return a list of those greenlets for later analysis.

The `get_server_stats` function talks to the actual gameservers and looks like:

    def get_server_stats(address):
        server = ServerQuerier(address, timeout=SERVER_TIMEOUT)

        try:
            ping = server.ping()
            info = server.get_info()
            # Also available: server.get_players()

            logging.info(u'Updated {0}:{1} {2} @ {3}ms'.format(
                address[0], address[1], info['server_name'], ping)
            )
            return True

        except (NotImplementedError, NoResponseError, BrokenMessageError):
            # Ignore UDP or protocol errors
            pass

All this does is fire off a couple of UDP requests to the server and hopefully get valid responses - if not we simply ignore as UDP is flakey.

The full code (including collecting number of successes/etc) is [in this gist](https://gist.github.com/Fizzadar/3093d07aa99abc636944/a33fbdbbb55ca5143d9a62008a22888bb55564d5). Unfortunately this approach only finds ~7000 servers each run of which ~1000-1500 return a response - this is not good enough.

### Tuning the master server query

The master server(s) are not very keen on sending a full list of every server they know about - according to [the python-valve docs](https://python-valve.readthedocs.org/en/latest/master_server.html) it's way more effective when using (region) filters. The masters are also quick to rate-limit too many requests in a short period. Luckily the _official_ address (`hl2master.steampowered.com`) actually points to three IPs - meaning we can round-robin requests between each. Using per-region requests split between the master server IP's should dramatically improve the number of gameservers we discover.

So lets modify `find_servers` to take a host and region:

    def find_servers(host, region):
        count = 0
        greenlets = []
        master = MasterServerQuerier(
            address=(host, 27011), timeout=MASTER_TIMEOUT
        )

        try:
            for address in master.find(region=[region]):
                greenlets.append(pool.spawn(get_server_stats, address))
                count += 1

        except NoResponseError as e:
            # Protocol is UDP so there's no "end"
            if u'Timed out' not in e.message:
                logging.warning('Error querying master server: {0}'.format(e))

        finally:
            logging.info('Found {0} addresses'.format(count))
            return greenlets

And now we can spawn a greenlet for each region, rotating between hosts using a [`deque`](https://docs.python.org/2/library/collections.html#collections.deque):

    MASTER_HOSTS = deque(['208.64.200.52', '208.64.200.65', '208.64.200.39'])
    VALVE_REGIONS = [u'na', u'sa', u'eu', u'as', u'oc', u'af', u'rest']

    ...

    for region in VALVE_REGIONS:
            pool.spawn(find_servers, MASTER_HOSTS[0], region)
            MASTER_HOSTS.rotate(1)

Using these modifications a single run is now able to pick up ~30-50k addresses each time. This combined with a pool/gevent size of 3000 (don't forget `ulimit -n` first!) was able to collect ~20k/50k addresses in under a minute. The full code for this approach is also found [in this gist](https://gist.github.com/Fizzadar/3093d07aa99abc636944/b766b28c6ccec274e00b4c9ce5601dbbd12c9859).

### Wrap up

So, using asynchronous requests, we are able to collect statistics from tens of thousands of gameservers in under a minute - all in under 100 lines of Python. I am using these techniques in the new [collector daemon](https://github.com/Fizzadar/SourceServerStats/blob/develop/sourcestats/collector/__init__.py) as part of my [Source Server Stats](http://sourceserverstats.com) rebuild.
