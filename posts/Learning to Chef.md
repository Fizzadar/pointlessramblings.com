$mast=chef
$date=05/04/2014

Over the last three months I've been learning how to cook with Chef. Prior to this I have stuck faithful to bash scripts for provisioning servers, and Chef/Puppet/Ansible/etc all claim to make this job a whole lot easier. Having now used Chef extensively, I can for sure say it does _not_ make the job of deploying easier.

My first encounter with Chef was when working in a Vagrant box to deploy a simple Django app and a couple of email related services. The first thing I noticed when reading through the recipe was that each block could easily be written as a single line in a bash script - it seems like writing a lot of extra code because it's simply easier than writing it out in bash (with all it's pitfalls). Nonetheless I ploughed on and after a few weeks was writing my own Chef scripts to deploy other services. Then the real problems began.

One great feature of Chef is the ability to include other peoples recipes, taking away a lot of the hard work. However on multiple occaisions I've included recipes which either 1. no longer exist or worse 2. references packages/other recipes/files which don't exist. Not only is this frustrating to deal with, but trawling through Ruby's awful tracebacks is certainly not enjoyable. Finally is the attribute system, with a nice and simple fifteen(!) levels of attributes, which require some serious studying to learn by heart.

In my experience all of these problems result in one thing: a decrease in developer productivity. We're not fighting with wierd configs & bash scripts, but instead spending days debugging Chef code. I'm 100% certain I could bash-script deploy anything (including groups/multiple servers) quicker than I could with Chef.

Thankfully there are many other options, such as:

+ **Bash**: still my favoruite - extremely powerful & flexible, great for deploying/installing single machines
+ **Fabric**: is like an enhanced form of bash using Python
+ **Ansible**: great for keeping consistent configs across larger groups of nodes