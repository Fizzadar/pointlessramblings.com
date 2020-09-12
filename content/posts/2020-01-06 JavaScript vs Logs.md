---
title: JavaScript vs Logs
date: 2020-01-06
---

A war has been raging over the last few years between consumers and advertisers. A never ending cat and mouse game where each side tries to out-do the other. It's tracking vs blocking, clicks vs privacy, readers vs publishers.

Gone are the days when adding the GA/et-al snippet to your blog captured almost every user. My theory is that, for tech oriented blogs, GA misses a significant portion of traffic. Tech readers are more aware and actually care about their privacy online.

But how big is the problem? What am I not seeing in GA? Am I talking a load of nonsense? To find out I used [GoAccess](https://goaccess.io/) to parse & track the stats for this blog from the nginx logs. The results have been quite revealing. Let's look at February to July of 2018:

![](/img/posts/javascript_vs_logs/ga_vs_goaccess.png)

That's a huge difference! Much more than I ever expected. Note that this after some cleanup. GoAccess uses servers logs so all traffic counts - including crawlers, static files and bad actors. The logs were filtered and processed as so:

```sh
# GET requests, 200 responses, no static/invalid files
grep "GET" access-feb-jun.log | \
    grep '" 200 ' | \
    grep -vE "\?|\x|http" | \
    grep -vE "\.(png|php|css|ico|xml|js|jpg|zip|cgi|gif|woff|woff2|eot|svg|ttf)" \
    > access-feb-jun-clean.log

# Parse with goaccess, removing redirects and crawlers
goaccess \
    --log-format=COMBINED \
    --ignore-crawlers \
    --ignore-status=301 \
    --ignore-status=302 \
    -o report.csv \
    access-feb-jun-clean.log
```

The result gives a clean(ish) log of legit traffic - which is roughly what GA should be tracking. As we can see, this is not the case - not even close. Even if we account for 10% still incorrect logs - **GA is missing roughly 70% of traffic to this blog**.

I have removed GA as it's both useless and a privacy concern for anyone not using a blocker. The results provided by GoAccess are more than enough, even if they contain a few false positives.

---

Bonus item!: using server logs means tracking (rough) RSS readership is possible!

```sh
# GET requests, 200 responses, no static/invalid files
grep "/index.xml" access-feb-jun.log \
    > access-feb-jun-rss.log

goaccess \
    --log-format=COMBINED \
    -o report.csv access-feb-jun-rss.log
```
