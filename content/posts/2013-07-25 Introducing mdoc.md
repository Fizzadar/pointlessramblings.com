---
title: Introducing mdoc
date: 2013-07-25
mast: mdoc
aliases:
    - /posts/Introducing_mdoc/
---

[**View on GitHub**](http://github.com/Oxygem/mdoc) / [**View Demo**](http://doc.oxypanel.com)

Over the last two days I've been writing a small PHP-powered markdown based documentation/wiki/website 'generator' called [mdoc](http://github.com/Oxygem/mdoc).

### Inspiration / Why

I recently set up [Daux.io](http://daux.io) to document [Luawa](http://github.com/Fizzadar/Luawa). Daux _looks_ very nice and runs well, however the UX is flawed in that the left navigation column takes up way too much space, leaving a (too) thin column in the middle for text, and code on the right in another (too) thin column. The design is also wrapped up in the index.php file, making modifications to it significantly more complicated.

So I decided to make an extremely simple wrapper which basically takes a header and footer template and sticks them either side of a markdown document.

### Markdown + some

The markdown files used by mdoc can contain some extras which allow you to set page title, desctiption and other template-related data. For example:

	#title=This is a page title

Will assign template data with key ""title"" and value "This is a page title". The definitions are then removed from the file before the remaining content is rendered as normal.

Interlinking between pages is essential, but I wanted to make sure that you could use relative links without worrying about the directory mdoc is running from if not on the root of a domain. Thus the following code will be matched and have the correct url prepended to it:

	[link name](/some/internal/document)

### Demo

Although there's almost no content (yet) here's an example: [Oxypanel Docs](http://doc.oxypanel.com).

### Setup

Installation is as simple as:

+ rename config.example.php => config.php (edit if needed)
+ stick markdown files in src/doc/ (needs home.md - can be changed in config)

### Modification

The default template is usable (just!), but the whole purpose of the project was to build a system in which one can integrate the documentation into the projects main website. Templates only consist of a header.php and footer.php, and has a very simple API for getting variables set internally or via the special tags in markdown described above:

	<?php echo $this->getData( 'key' ); ?>

### Use

I hope someone can find a use for this either for project documentation, a wiki or even a static website. It's released under the [WTFPL](http://www.wtfpl.net/).

[**View on GitHub**](http://github.com/Oxygem/mdoc)
