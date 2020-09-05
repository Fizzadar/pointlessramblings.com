---
title: Agentless Everywhere
date: 2016-08-13
mast: agentless_everywhere
---

In a world where everything must be distributed across multiple servers, datacenters and continents the task of managing & monitoring server state has become significantly more complex.

Hundreds of solutions have spawned in recent years - and in general these tools can be split into two groups: [those](https://sensuapp.org) [with](https://puppet.com), and [those](https://github.com/Fizzadar/pyinfra) [without](https://github.com/fabric/fabric), agents on the target servers. I'm writing this post to argue in favour of the agentless tools.

.

One shouldn't need to install (sometimes closed source!) software on a server to have it managed or monitored. Agents take up precious CPU, memory and disk space which should be reserved for the actual thing the server is meant to be doing. Then there's updates - does it make sense to have to update _every_ server to fix a bug in the agent? With an agentless tool you'd just update a client or have the service provider handle it for you.

Take Sensu for example, it weighs in at ~30MB of package data (via apt) including a full Ruby interpreter. And then there's the check files - every time these change they need to be synced to all the servers that use them. The problem really begins to manifest at scale, where deploying such changes takes a non-trivial amount of time.

Another good example of "agent bloat" is Chef (which also bundles it's own Ruby interpreter) - the base `ubuntu` Docker image weighs in at a cool 126MB - not too shabby. Want to install stuff on it with Chef solo? You might try the `linuxkonsult/chef-solo` image - it's 671MB. That's a whopping 545MB of pointless bloat!

.

The [case](https://www.sciencelogic.com/blog/agent-vs-agentless-monitoring) [for](http://www.midvision.com/resources-blog/bid/273230/Agent-vs-Agentless-Deployments-Part-1-Agent-Based-Deployments) [agent](https://www.controlup.com/blog/agent-agentless/) based systems is mostly centered around security and the ability to provide more in-depth data (eg using a MySQL library to collect stats).

From a security perspective I would argue that installing someone elses software with often root-level access is _not_ secure - even if you trust they won't fiddle with your shit. Without reading (if even possible) through the entire source code, it's impossible to guarantee bad stuff won't happen.

Collecting more detailed data is also a non-issue, given that servers host clients for their services (eg a Redis box also holds `redis-cli`), collecting such information is normally trivial:

    echo "SHOW STATUS LIKE '%wsrep';" | sudo -u mysql mysql

By using the very tools an ops person would use, an agentless system can extract any stats as needed. Unix pipes were built for this kind of automation. The output can be parsed with `awk` or be passed to the monitoring system as-is for further processing. Simple techniques like this can be used to collect/alter state of a huge array of services, using just a shell on the remote servers.

.

"Agentless" systems avoid these problems by using an older, more generic agent(!) called `sshd`. Ops/admins/whatevers use it daily to manage and monitor servers, it's very secure and extremely well tested throughout the years. It makes sense for automated systems to use it too.
