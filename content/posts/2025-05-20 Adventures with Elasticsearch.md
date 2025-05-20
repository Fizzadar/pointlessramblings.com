---
title: Adventures with Elasticsearch
date: 2025-05-20
---

At old work we did some pretty wild things with Elasticsearch. It’s been a few years for my memories to rot but roughly we’re talking thousand node clusters, a petabyte of data and billions of documents.

We didn’t just do search though, nor just metrics. We combined the two together so you could generate metrics over time filtered by many fields including paragraphs of text. Documents were large and contained both searchable text, keywords and associated metrics. I am not aware of another database that can do that at this scale (probably does exist by now).

But. While it was impressive it was a fucking nightmare to manage. Elasticsearch has some weird gotchas. Let’s start with its discovery and quorum system, which is responsible for ensuring consistent cluster state and preventing split brain situations.

### Leader Election & Cluster State

You might expect Elasticsearch to use a well known, formally proven algorithm like Raft or Paxos. It doesn't. Maybe they offload this problem to a system designed for distributed data like Consul or Zookeeper. Also wrong. The best option was obviously to build one in-house. The [Jepsen results were not pretty](https://aphyr.com/tags/elasticsearch).

Unfortunately no public Jepsen tests in many years so the situation has likely changed. Indeed v7 [introduced an updated discovery system](https://www.elastic.co/blog/a-new-era-for-cluster-coordination-in-elasticsearch)... still in-house design and build. You can read the post, it has a bunch of excuses for not just using Raft that implies a preference for availability over consistency, something to be mindful of.

We used both the pre-7 and 7 version. The newer 7 version is indeed vastly superior, but the bar was exceptionally low. The bar is "does not lose entire cluster state at regular intervals". Once we'd upgraded the majority of cluster state issues went away, but we could never get a cluster stable with over 1000 nodes. The new state sharing mechanism simply could not handle clusters above a certain size. In the end we split the cluster into 5, which was a good call anyway and our cluster state problems went away.

### Data Balancing

Let’s just assume you have a perfect network and hardware and the leader election stuff is working flawlessly. Now you have to load up some data nodes and shove some data into them. You load up 100TB of documents over a bunch of daily indices and start querying but immediately you notice a few things: some nodes run very hot while others seem to be empty. Let’s dig into that.

Like pretty much every distributed database Elasticsearch stores data across multiple shards. One of the critical tasks of a distributed database is balancing these shards across the N machines available. I'm sure you can think of some metrics which might be useful for achieving this balance: disk space, shard count, CPU/memory/IO utilization, etc.

What did/does Elasticsearch do? Shard count. That's it, nothing else is considered when it comes to balancing a set of shards over nodes. Clearly this eventually caused problems so they added high/low disk space watermarks to prevent a node receiving more shards. This of course leads to an imbalance in the number of shards, which leads the cluster to attempt to rebalance.

In effect what you end up with is an infinite (both time and stupidity) loop that constantly moves _the same two shards between the same few nodes_. I recall the entire team tearing their hair out trying to explain this. Eventually we figured it out and wrote a tool that rebalances disk space without impacting shard count balance, [elasticsearch-rebalancer](https://github.com/EDITD/elasticsearch-rebalancer).

### The Killer Client

The final nail in the coffin, so to speak. Elasticsearch provides official clients for a number of languages. We used the Python one. What would you guess it's default behavior is when a request times out (which one might imagine is due to a very big query)? Ah yes, that'd be retry it on another node. You can see where this is going...

So there you are, a rogue user has created a monster query that takes down one of your query handling nodes. You think you've time because the request will error out. Calmly and quickly you run through the logs, looking for.. _boom_ nope, hold on, same query has hit the next node. And a few seconds later the next one. Whole cluster is dead, one query.

This is really, really poor client design. This is a client that has unfettered access to a potentially enormous amount of data with arbitrary search and query functionality. If you hit a problem, you don't fucking retry it by default.

Easy fix, just change the client config. But seriously, where's the care for people using this tech. Default retries seems like a bad thing in any client library (explicit > implicit).

---

So there you have it! Elasticsearch is a very cool piece of technology with incredible capabilities, but it was (at least during our experience) far from pleasant to work with. While it has evolved since then, these fundamental design decisions and their implications are worth considering for anyone planning to use Elasticsearch at scale. The lesson here? Sometimes the most powerful tools come with the most challenging trade-offs.
