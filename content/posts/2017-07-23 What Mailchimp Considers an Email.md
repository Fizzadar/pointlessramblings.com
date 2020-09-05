---
title: What Mailchimp Considers an Email Address
date: 2017-07-23
mast: failchimp
---

Recently I've been working with Mailchimp's API. The task was simple: to write a script to keep in sync an internal user list with a Mailchimp mailing list - simple stuff. I set about writing the thing and, bar for the fairly regular API timeouts (don't batch >500), all was good.

And then I ran the thing.

After a couple of hundred users the script encountered an error - apparently one of the email addresses was _invalid_. At first I thought this was an issue in the unofficial and excellent [python-mailchimp3](https://github.com/charlesthk/python-mailchimp), so I created an [issue](https://github.com/charlesthk/python-mailchimp/issues/116). Then, while working on a PR to close the issue, I discovered [this gem](http://kb.mailchimp.com/accounts/management/international-characters-in-mailchimp) in the Mailchimp documentation:

<blockquote>Although MailChimp can process UTF-8 characters in most parts of our application, we cannot process UTF-8 characters in your subscribers' email address prefixes</blockquote>

Seriously?

UTF-8 email addresses became [standard in 2012](https://tools.ietf.org/html/rfc6531), Gmail [added support](https://www.theverge.com/2014/8/5/5971477/gmail-recognizes-email-addresses-with-non-latin-characters) for this in 2014, as [did postfix](http://www.postfix.org/SMTPUTF8_README.html). Microsoft dragged their feet for a few years and added support to [Outlook 2016](https://support.office.com/en-gb/article/International-email-addresses-303595ea-4893-4b26-9b14-2202c32fea36).

I totally get that a change from ASCII to UTF-8 is non-trivial when you're dealing with millions of email addresses; so it's understandable that some businesses still don't support this. But Mailchimp? Aren't they meant to be at the forefront of email marketing? How can you run mail campaigns without access to these users? Ridiculous.

--

Update 26/7/17: change email -> email address as it's correct ([thanks HN!](https://news.ycombinator.com/item?id=14831756)).
