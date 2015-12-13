$date=14/01/2014

A couple of days ago I saw [pngquant](http://pngquant.org/) appear on Hacker News. I'd never really looked in depth into image compression, and after reading up on the subject I scanned through the comments on HN, discovering a number of alternative png (and other formats) optimisers. So I decided to benchmark/compare [pngquant](http://pngquant.org/), [pngcrush](http://pmt.sourceforge.net/pngcrush/), [optipng](http://optipng.sourceforge.net/) and [pngnq](http://pngnq.sourceforge.net/).

--MORE--

### Setup

**Images**: I tested a number of different images, some of which you'd be insane to render in PNG and more that make sense. The images vary greatly in size, colors and alpha channels and should be a good test for each of the optimisers. To ensure a fair test I opened & exported all the images with Photoshop, to give them all a consistent encoding algorithm.

**Optimisers**: I used the latest stable copy of each: pngquant 2.0.1, pngcrush 1.7.70, optipng 0.7.4 and pngnq 1.1.

**Commands**:

	pngquant --speed 1 *.png
	pngcrush <name>.png ../after/pngcrush/<name>.png
	optipng -keep -o7 *.png
	pngnq -d ../after/pngnq/ -s 1 *.png

### Results

The raw results & images can be [downloaded here](/inc/files/png-optimisers.zip). 

I put together the result in a [Google Docs spreadsheet](https://docs.google.com/spreadsheet/ccc?key=0AkRYIVqSDsRbdFU3R1N3c0FUT1FxUFNIMFdWY29odHc&usp=sharing) which shows the sizes per-image before and after each optimiser as well as the reduction percentage. I also gave the image a quality rating (in comparison to the before image) on a scale of 1-10, where 10 is pixel for pixel perfect. Bear in mind this is only as accurate as my eyes, you should take a look at the images to decide for yourself. The highlights:

+ **pngquant average reduction / quality**: 63.91% / 8.5
+ **pngcrush average reduction / quality**: 4.75% / 9.88
+ **optipng average reduction / quality**: 13.48% / 9.88
+ **pngnq average reduction / quality**: 63.93% / 6.62
+ Both **pngquant** and **pngnq** have offer the best reduction (63.91%, 63.92% respectively)
+ **optipng** and **pngcrush** retain the best quality


### Conclusion

The results can be split in to two groups; one in which images loose almost no quality but space savings are minor and another where the quality is sacrificed in favour of significantly higher space savings. There is a clear winner here though, I will definitely use **pngquant** as my go-to optimiser, as it offers fantastic size reduction while keeping an acceptable/good level of quality.
