---
title: Why You Should Try pyinfra
date: 2019-11-30
mast: pyinfra
mast_background: '#1D1D1D'
aliases:
    - /posts/Why_You_Should_Try_pyinfra/
---

These days tools to automate, provision or configure servers are dime  a dozen. There’s Puppet, Chef, Salt, Ansible and so on. They all suffer from “over abstraction” - each has it’s own  syntaxes and debugging processes. This is far removed from a manual  provision over SSH, where feedback is instant. These tools work a dream,  until they don’t.

This is why I built [pyinfra](https://pyinfra.com).

pyinfra is what you’d get if you merged the good bits of Ansible and  Fabric together. It’s flexible (all the Python packages), super fast and facilitates instant debugging. `-v` gives you the raw output as it executes commands. It works by executing simple shell commands, as you would doing a manual provision. This has the added advantage of a `--dry` flag for dry runs.

If you know Python then you already know how to write pyinfra inventory & operations. Better still if you know Ansible, you'll understand the concepts of groups & data too.

In short a pyinfra deploy looks like this:

```py
# deploy.py
from pyinfra.modules import apt

apt.packages(
    {'Install iftop'},
    'iftop',
    sudo=True,
)
```

Execute this like so:

```sh
pyinfra myserver.net deploy.py

# This is identical to:
pyinfra myserver.net apt.packages iftop sudo=true
```

This is roughly what you'll see:

![](/img/posts/why_you_should_try_pyinfra/example_deploy.gif)

---

So - why should you try pyinfra; what sets it apart from other tools?

### 1. Python, Python, Python

Everything  in pyinfra is Python - inventory files, data files,  operation files. This means they are all compatible with Python packages.  If you need to do something in pyinfra you use the existing Python package. Setup an EC2 instance to target, manage encrypted secrets, call an API - the possibilities are endless. Check out [the example deploys](https://pyinfra.readthedocs.io/en/latest/examples.html).

### 2. Debugging that isn't awful

One of the nice things about deploying “by hand” is that, ~~if~~ when something goes wrong, you get instant feedback via stdout/stderr. This is not true for most deployment tools.

Because most pyinfra operations execute shell commands, feedback is instant. If anything goes wrong pyinfra will give you any output immediately. If you want to follow both stdout/stderr as the deploy executes, add `-v`.

### 3. Actually agentless

pyinfra works over SSH and only requires a shell on the remote side. There's no daemon or even Python required. If you can SSH into it, pyinfra can deploy to it.

pyinfra can also build Docker images, execute with subprocess and read Ansible inventories. Other execution targets and inventories are trivial to implement.

### 4. Performance

In an agentless system, where a single process handles the entire deployment, performance is key. One of the reasons I started pyinfra was frustrations with Ansible's (at the time) slowness. pyinfra boasts significant performance gains over Ansible and falls much closer to fabric:

![](/img/posts/why_you_should_try_pyinfra/performance_chart.png)

### 5. Package, extend, distribute

pyinfra leverages Python's existing packaging infrastructure to create [re-usable deploys](https://docs.pyinfra.com/en/3.x/api/deploys.html). There are deploys for [etcd clusters](https://github.com/Fizzadar/pyinfra-etcd), [Docker](https://github.com/Fizzadar/pyinfra-docker), [Kubernetes clusters](https://github.com/EDITD/pyinfra-kubernetes), [Prometheus](https://github.com/grantstephens/pyinfra-prometheus) and more.

.

So, if you're still here, why not [try pyinfra](https://pyinfra.com)?
