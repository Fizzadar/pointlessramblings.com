---
title: Migrating this Blog to Hugo
date: 2020-10-07
---

This post marks the first release of this blog built using [Hugo](https://gohugo.io/); hopefully nothing looks out of place! Hugo replaces my own [Luapress](https://luapress.org) that was in use since 2013. Hugo brings more functionality enabling me to do more interesting stuff without having to implement it myself. A blogroll, link summary posts or even a shit company rant section (another place to rant alongside Twitter). Back on topic, this post is about my experience rebuilding this blog using Hugo.

### Everything is a Page

Hugo is well documented and has plenty of community support. It's taken maybe 4 or 5 hours to do the migration. BUT - at the start I found some of the ways Hugo processes content to be confusing, and found little to no description of _how_ this works. Let's look at adding content in [the quickstart example](https://gohugo.io/getting-started/quick-start/):

```sh
hugo new posts/my-first-post.md
hugo serve
```

... and just like that - a blog! OK, but Hugo builds all kinds of website, how's the post appearing on the homepage? What happens if I make a `/pages/info.md`? I did and... it appeared on the homepage as well - hmm.

Through much searching and browsing of example websites, I discovered that, quite simply, _everything is a page_. Blog posts are just pages. It's the template that defines how, and more importantly which, pages are displayed. My mistake was thinking templates were simply a definition of look, like a WordPress template. Instead templates convey both look and function. That is to say that templates need to be content aware, and content needs to be template aware - the two go hand in hand. For example, to render only blog posts on the homepage, the homepage template would contain something similar to:

```html
{{ range (where .Site.RegularPages "Section" "posts") }}
    {{ .Render "post" }}
{{ end }}
```

OK, now we're in business.

### Building the Template

Now that I'd wrapped my head around the content <> template interaction, it was time to port over the "Pointless v10" template. Hugo uses Go's builtin templating and it is _awesome_, a major step up from Mustache. The block based inheritence and general syntax is much like jinja2 or Django and so felt immediately familiar.

I skipped most of the documentation on themes and jumped right in starting with the [Smol theme](https://github.com/colorchestra/smol) which seemed like a suitable bare-bones starting point. That, along with [the blog example site](https://github.com/gohugoio/hugo/tree/master/examples/blog) and it only took an hour to do most of the conversion.

The only complex part was re-creating the [masts list on the info page](/pages/info#index-masts), which was previously generated via [Luapress plugin](LINK) (ie a Lua script):

```html
{{ range $year := (sort (readDir "static/masts/home") "Name" "desc") }}
    {{ range $month := (slice "December" "November" "October" "September" "August" "July" "June" "May" "April" "March" "February" "January") }}
        {{ $filename := printf "masts/home/%s/%s.jpg" $year.Name $month }}
        {{ if fileExists (printf "static/%s" $filename) }}
            <img src="{{ $filename | relURL }}" />
        {{ end }}
    {{ end }}
{{ end }}
```

### Permalink Changes

Finally the other hurdle to deal with was the permalinks! Luapress was generating links using underscores and no "slugification" of post titles. I much prefer Hugo's slugified post URLs but needed to gracefully transition these over. I spent some time looking for an nginx solution until I discovered Hugo itself can handle this! All it takes is a simple alias flag in the old posts:

```html
aliases:
    - /posts/Why_Always_Docker/
```

### Hugo and Beyond

That's all there was to it - a smooth experience moving over to Hugo. Although I have no immediate changes planned, it's now possible for me to modify and/or create content on this blog, my small slice of the internet.
