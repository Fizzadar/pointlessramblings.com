---
title: Why Always Docker?
date: 2016-01-17
mast: docker_all_the_things
---

I love Docker. I've recently spent a lot of time learning about both Docker & Kubernetes. Combined with stateless containers they provide fantastic scalability, service discovery and near-instant deploy times (excluding initial image build!).

There is a trend, however, of using Docker containers for _everything_, and this makes no sense to me.

.

Let's look at an example - running a Docker Registry (v2). I want to:

+ Run a single instance of the Go binary
+ On a box with huge disk space & bandwidth
+ And relatively low CPU/memory

I don't want such a box in my Kubernetes cluster (it's a one-off), and I need none of Dockers scaling properties, so I'll run it direct on hardware.

Well, guess what? There's no install instructions for that. In fact, the "official" way is _use the Docker image_. Luckily the `Dockerfile` isn't much more than a limited shell script, so following the trail of [docker/distribution](https://github.com/docker/distribution) -> [Registry Image](https://hub.docker.com/_/registry/) -> [Dockerfile](https://github.com/docker/distribution-library-image/blob/0258654c749c96ca876b1d9ce456bee42b6794de/Dockerfile) I was able to recover manual install instructions (all two of them).

.

While we're discussing the `Dockerfile`, let's look at some other services better suited off-Docker: datastores. Say you want to run an Elasticsearch or Galera cluster - Docker containers might offer a ridiculously quick setup and look awfully tempting.

But wait - how do we configure these services for multiple environments (test/prod clusters)? They don't read our `ENV`vars, nor do they know of our internal service discovery tools. These kind of systems have their own configs, be it `elasticsearch.yml` or `my.cnf`. The `Dockerfile` format is completely fucking useless at this kind of thing.

Unfortunately [it](http://blog.tryolabs.com/2015/03/26/configurable-docker-containers-for-multiple-environments/) [would](https://blog.codeship.com/cross-platform-docker-development-environment/) [appear](https://groups.google.com/forum/#!topic/docker-user/Vi6oj9FW2m4) the popular solution is simply to install other utilities within your image, and have them "bootstrap" the configuration before running the service. That's mental, and a massive middle finger to the idea of containers without non-production-dependent software. Tools like [pyinfra](https://github.com/Fizzadar/pyinfra) and [Ansible](https://github.com/Ansible/ansible) are much more suitable for this kind of work (and don't install useless crap to generate a config file).

.

On the flipside - _having readily available instances of Elasticsearch/Galera/etc is incredibly useful in the development stages of a product_. The ability to rapidly bring up a _single_ Elasticsearch instance attached to some branch of app is a huge time saver. It's by far the best way to deploy stateless apps one has control over. Just don't bother building clusters of complex third party software with Docker containers.
