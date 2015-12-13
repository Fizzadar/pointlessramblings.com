$date=08/04/2015

Since the earliest programming days hackers have benchmarked and compared pretty much every language/software/stack out there. These benchmarks are often shared with the public, which allows other hackers to make more informed tooling decisions based on their specific problem. Although this is an awesome feedback system, I worry that recently the quality of benchmarks has been affected...

--MORE--

Since the recent shifts towards "Cloud" computing, I see a lot more of these benchmarks run on top of virtual machines (/cloud servers). Unfortunately this has the potential to, and often does, skew the results. This happens because, even though a virtual machine appears as a physical, separated device, it's really a shared environment - leading to inconsistent CPU/Memory/IO resources. For production deployments this varyation is annoying but managable, however when you're benchmarking and pushing something to the edge of it's limits, the varying access to system resources can have a much more profound affect.

Of course, phyiscal boxes aren't _that_ consistent either, it's very difficult to tell the OS to stop running all it's background processes. But the reality is they are far more consistent, with only a small variation in available system resources, and this will lead to more reliable benchmark results/comparisons. Just me make sure to close all other running userland processes if on a personal laptop/etc!

I like to think of benchmarks as a scientific experiment - one needs a control group to act as a "base". In computing you could call that "group" a device running an OS so lightweight it has a negligable affect on the available system resources. This gives a level playing field on which to benchmark/compare software.
