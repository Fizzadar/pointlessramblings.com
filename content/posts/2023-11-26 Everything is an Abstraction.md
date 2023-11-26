—
title: Everything is an Abstraction
date: 2023-11-26
—

Literally everything is an abstraction, and I’m not just talking about software. [This post presents an ominous future](https://unixsheikh.com/articles/we-have-used-too-many-levels-of-abstractions-and-now-the-future-looks-bleak.html). in which no one actually knows how to build things from the ground up.

I’m inclined to partially agree.

Let’s talk about Kubernetes, since it’s where I spend most of my ops-y time currently. How does one setup a Kubernetes? Well any documentation or tutorial you read will almost certainly point you at one of many tools that “does it all” for you. An abstraction.

There’s a time and place for these (at work we use, with great success, Rancher). In fact, I’d always recommend using such a tool in a production environment. Having other users using the same toolchain is great for troubleshooting and confidence building.

So am I complaining about abstractions or not? I believe that to truly know a system, you have to build it without relying on such abstractions. So if I’m hiring a “Kubernetes engineer” (whatever that means) I’d expect them to have bootstrapped a cluster “by hand” before. Simply knowing YAML specs does not count.

On the other hand though, I don’t care if you don’t know how to build a computer or write assembly code. I think one should always have  an n-1 abstraction layer knowledge. Software engineers should have an understanding of the protocols they build on top of. Devops teams (hate the term, but that’s another post) should know the underlying OS and some low level networking knowledge. One outside of software: house builders should have a grasp of the brick production process.

Writing all this down has made me realise it’s quite simple: understand the abstractions on which you build. If all you know is how to crank out whatever language code you’ll always be held back by a lack of understanding for the protocols and systems it runs on.