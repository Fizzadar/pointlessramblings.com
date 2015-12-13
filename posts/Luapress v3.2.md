$title=Luapress v3(.2)

Recently static website generators have been gaining [lots of attention](http://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/). Inspired by this I have been working on a new major [Luapress](http://luapress.org) version, targetting some of the annoyances I find when building this blog with it. A couple of weeks ago I released v3 and two additional minor versions; this post runs through some of the more exciting features and changes:


### Environments

With v2, you could pass in a URL to build against, and manually switch from the default `build` output directory using `--build`. v3 does away with this complex setup in favour of environments. These are defined in `config.lua` and basically define either one or both a URL and output directory. For example, my `config.lua` for this site looks like:

    config = {
        -- Default URL (pointing to default build/ output dir)
        url = 'localhost/Pointless Ramblings/build',
        ...
        envs = {
            -- Build against this URL, outputting to production/
            production = {
                url = 'http://pointlessramblings.com',
                build_dir = 'production'
            }
        }
    }

--MORE--


### Watch

I've wanted to support a `--watch` CLI argument for a long time - and now it's here. Running Luapress with `--watch` will cause it to watch for changes in `posts/`, `pages/` and your template (as of v3.2) and automatically build every time a change is detected. This makes the write -> build -> check feedback loop much, much easier to manage.


### Mustache (v3.1)

Luapress now has support for `.mustache` templates thanks to the [Lustache library](http://olivinelabs.com/lustache/). The old `.lhtml` templates remain supported, but since they're a hack I put together one evening, `.mustache` now powers the default theme.

Sometimes full Lua capability is useful in templates, so a mix of template types is also allowed. For example - this blog is `.mustache` powered except `header.lhtml` & `footer.lhtml` which [handle some logic](https://github.com/Fizzadar/pointlessramblings.com/tree/develop/templates/pointless).


### Build Options

While v2 really targeted blogs, v3 brings along full support for static websites without any posts. A page can be defined as the index rather than the standard posts, using `config.index_page`. In addition to this, the page can be forced to the index where there are posts, using `config.force_index_page`. The posts will still be generated, but the only index of them will be the archive page.

Another little feature is the ability to attach a page to the top of your index (above any posts), using `config.sticky_page`.


### What's Next

As with v2, I'll continue to use v3 to power this blog and a few other sites I maintain. I'm sure I'll soon find things that can be further improved. If you've any feature requests, please [create an issue](https://github.com/Fizzadar/Luapress/issues) and I'll see what I can do (or modify yourself, PR's always welcome!).

I also want to improve the documentation. I recently created a [Luapress microsite](http://luapress.org) (powered by Luapress, of course), but there's definitely room for improvement.
