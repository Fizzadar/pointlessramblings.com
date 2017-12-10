$title=Why Always Electron?
$mast=why_always_electron

[Electron](https://electronjs.org/) is fast becoming the go-to solution for non-desktop developers who want to build desktop apps. Say what you want about that ([I'm doing it!](https://github.com/Fizzadar/kanmail)) but, for better or worse, the trend of using web technologies for desktop is here to stay.

Unfortunately Electron comes a whole load of bloat. They tend to use high amounts of CPU and memory in return for  sub-native performance. Having each app bundle it's own Chrome install is completely fucking ridiculous. A great example of how to waste your users disk, memory and CPU en-masse.

.

Slack is a perfect example of this. Apparently this was [fixed in March](https://slack.engineering/reducing-slacks-memory-footprint-4480fec7e8eb), yet the [HN comments](https://news.ycombinator.com/item?id=13785793) and [this recent account](https://medium.com/@matt.at.ably/wheres-all-my-cpu-and-memory-gone-the-answer-slack-9e5c39207cab) disagree. I fired up Slack to check this out for myself and, guess what? Slack is still a CPU (and somewhat memory) whore - it’s just less so:

![]($=url/inc/posts/why_always_electron/slack_resources.gif)

So with a single team Slack needs ~480MB memory. Not great (esp. for a  glorified chat app), but not awful. But try hovering over  messages within the app and you’ll see massive CPU spikes (all that changes is the background color!). On my 8GB Macbook with it’s paltry m5 this is unacceptable.

.

There is a lighter alternative! [pywebview](https://github.com/r0x0r/pywebview) is a Python wrapper that uses platform specific native  web views. Instead of selfishly bundling Chrome into your app - it uses your OS platform’s native web renderer! Sure, it’s a bit more  work to ensure it’s compatible - but isn’t that worth the countless CPU  hours you’ll save your audience?

Loading the same Slack team gives ~335MB memory usage and a much better CPU load from it’s single process:

![]($=url/inc/posts/why_always_electron/slacklite_resources.gif)

Although I would recommend against it, the code to run SlackLite (this is a joke), is available [in this gist](https://gist.github.com/Fizzadar/3e44babe768edbc2974fa5a7ba49f90a). I do actually use this when on my Macbook!

There are also some other projects, like [Shrinkray](https://github.com/francoislaberge/shrinkray) and [Electrino](https://github.com/pojala/electrino), working on building a lighter Electron. I have not tested them yet as they are still missing some key features.
