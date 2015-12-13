$date=10/06/2015
$mast=el_capitan
$title=El Capitan for Developers


In spite of the risks, I always install the latest OSX betas on my personal laptop/dev-machine. This always brings a whole host of compatability issues and broken things, but fixing/discovering these is all part of the fun! This post is a summary of issues/solutions found so far - hopefully it'll be of help to someone. I shall keep updating as I discover more.

--MORE--

### /usr/bin

`/usr/bin` is no longer writeable - not even by the root user. Although `/usr/bin` should be left to the OS, I'm surprised not even the root user is allowed to fiddle with it's contents. Anything that was previously installed in there will be removed during the 10.11 install.

    $ sudo touch /usr/bin/test
    touch: setting times of ‘/usr/bin/test’: No such file or directory

### Vagrant

This breaks vagrant which insists on installing it's executable to `/usr/bin`. To fix just link the original to `/usr/local/bin`:

    $ sudo ln -s /opt/vagrant/bin/vagrant /usr/local/bin/vagrant

### Homebrew

My entire brew install was completely busted. The reinstall instructions recommend removing `/usr/local/Cellar` as well as `/usr/local/.git`, but this would mean unnecessarily removing everything I had installed (which was all working correctly). To fix:

    $ rm -rf /usr/local/.git
    $ brew cleanup
    # reinstall brew via the brew.sh script

You'll also need to install the latest command line tools for Xcode 7 to upgrade anything compiled by brew.

Installing git 2.4.3 failed because OpenSSL was missing, fixed with `brew install openssl`.

At first the latest `python`, `pypy` & `node` remained un-upgradeable - thankfully [@davzie](https://twitter.com/davzie) solved these issues by running:

    sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer

### Little Snitch

Little Snitch now has a [nightly release](https://www.obdev.at/products/littlesnitch/download.html) with El Capitan compatability.

### gevent / uwsgi with pip

CFLAGS="-std=gnu99" pip install -r requirements.pip

