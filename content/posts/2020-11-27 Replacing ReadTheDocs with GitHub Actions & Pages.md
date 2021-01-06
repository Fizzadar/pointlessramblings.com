---
title: Replacing ReadTheDocs with GitHub
date: 2020-11-27
---

I've been putting significant effort into improving the [`pyinfra` documentation](https://docs.pyinfra.com) as of late. This has meant many builds via, and much waiting on, ReadTheDocs. I'm a huge fan of the service, but recently it has felt like build times have slowed to a crawl. I already use GitHub actions/pages for this blog and have been thoroughly impressed so far, so I set about figuring out how to move the documentation.

The whole process took a few hours and consisted of three main things to implement.

### The Workflow

The meat of the project - generate the documentation, commit and push to the git repository. For the most part, this was a copy paste job from [the deploy workflow for this blog](https://github.com/Fizzadar/pointlessramblings.com/blob/main/.github/workflows/generate-deploy.yml). Roughly, the steps required are:

1. Clone both main `pyinfra` + generated docs repository
2. Install the package with docs requirments
3. Build the docs, writing into the generatic docs repository
4. Push any changes to the docs repository

You can [see the complete workflow configuration here](https://github.com/Fizzadar/pyinfra/blob/master/.github/workflows/generate-deploy-docs.yml).

### Page Redirects

When you hit the index page of RTD hosted documentation, you'll be redirected to the _actual_ index page of the chosen default version. Another useful feature RTD offers is "page redirects". These mean that navigating to `/page/X` will redirect you onto the default version of the documentation, so `/page/intro.html` becomes `/en/1.x/intro.html`, and so on.

This was a feature I completely forget about; I was about to make the DNS switch to GitHub when it occurred to me these redirects would all start failing! I quickly threw up the redirects using a simple HTML page with meta tag redirect.

Since GitHub pages doesn't allow custom nginx/etc routing, it's not possible to completely replicate the RTD redirects. I will have to manage these by hand. Luckily the documentation is split by major version only, so changes are very rare.

### Version Notices

The final feature of RTD I needed to replicate was the out of date version notice. For example see an [older version of the ES Python client](https://elasticsearch-py.readthedocs.io/en/7.9.1/) - a little warning message will popup after the page loads (JavaScript powered).

To replicate this I decided to implement such a feature as part of the template itself - flexibility afforded by using a custom Sphinx template. This is [implemented by three theme variables](https://github.com/Fizzadar/guzzle_sphinx_theme/commit/1bfe0c9cd0a17c1a34264fef715ce37c05a1a560) that track available, latest and "primary" (ie default) versions. Once the template was setup it was simply a matter of [adding the variables in the Sphinx configuration](https://github.com/Fizzadar/pyinfra/commit/86da9f19f1415e152790273ac7c0f8165c9fe719) to the project.

This doesn't _exactly_ match the RTD version, which also sends you to the same page on the newer versions. This is something I might implement in the future. However I did go further than RTD in terms of the messaging. Using three variables made it possible to show one message for unreleased documentation and another for out of date documentation. This can be seen by looking at the [`latest`](https://docs.pyinfra.com/en/latest) version vs legacy [`0.x`](https://docs.pyinfra.com/en/0.x).

### Summary

Overall - this was pretty easy to setup. The new builds are significantly quicker and trigger near-instantly on pushes to the repository. The documentation itself loads much faster benefitting from GitHub's distributed edge nodes. Wins all around. Be sure to [check out the documentation](https://docs.pyinfra.com)!
