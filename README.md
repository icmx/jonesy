# Jonesy

Jonesy is a poor man's feeds aggregator built on top of cURL, Python and shell. It works in the middle of user's reader application and original feed source which allows to synchronise feeds list between multiple devices and save original reder application experience.

One should consider that Jonesy is more of an idea than real software which is actually pretty crappy.

## Components

  - **jonesy-fetch** — script to retrieve feeds from original sources
  - **jonesy-serve** — script to host retrieved feeds for external reader application. It serves on 127.0.0.1 port 8600 by default.

## Setup

### Requirements

You need the following to use Jonesy:

  - Bash or other POSIX compatible shell
  - cURL more or less actual version
  - Python 3 with standard libraries (no external dependencies required)
  - Latest version of Jonesy, of course — grab it by git or manually.

You don't have to build something since it's just a couple of scripts — once obtained and configured, they're ready to go.

### Pre-launch Configuration

First, create hierarchy like here and don't forget to fill the jonesyrc:

```
  $JONESY_HOME
  ├── jonesyrc    (a file)
  └── jonesyfeeds (a directory)
```

> *Note: jonesyrc file syntax described [below](#jonesyrc-syntax).*

Next, add a bin directory from Jonesy repository (a cloned one) to your [`$PATH`](https://en.wikipedia.org/wiki/PATH_(variable)). For instance:

```bash
  export PATH=/home/user/git-projects/jonesy/bin:$PATH
```

To make `$PATH` changes permanent, one should add such line somewhere to ~/.profile, ~/.bash_profile or at least to ~/.bashrc.

Once `$PATH` modified, you have to run jonesy-fetch, give it some time and then run jonesy-serve.

## Usage

On this step you just need to connect external reader applcation to your new feeds. Suppose you have only one feed in your jonesyrc:

```
  url    = "https://www.reddit.com/.rss"
  output = "reddit.feed"
```

In classical way reader application connects to original feed URL — http://www.reddit.com/.rss, but since Jonesy retrieves and serves feeds locally, you have to use local feed link instead — http://127.0.0.1:8600/jonesyfeeds/reddit.feed. Note the path: `reddit.feed` is actually output file previously specified in jonesyrc.

Replace 127.0.0.1 by external address, e.g. http://example.org:8600/jonesyfeeds/reddit.feed if you run Jonesy on external host (like on home server).

### Automatic Updates

Jonesy is unable to update local feeds automatically, so you have to do that manually or set up a recurrent job by at, Cron, systemd or other suitable for your system. That job should execute jonesy-fetch from time to time in a way you like it.

If you don't like to set up scheduler or your system have no any, there is a backup plan: one should access to special URL that will signal Jonesy to update its feeds:

> http://127.0.0.1:8600/jonesyfetch

Or, if Jonesy is serving on another host:

> http://example.org:8600/jonesyfetch

This URL provides a single-entry feed which should be placed at the top of external reader application feeds list. That is application will first ask Jonesy to update local feeds and then it will download them. Unfortunately this won't work if reader application updates feeds in multiple threads.

## Configuration

### Environment Variables

  - `$JONESY_HOME` — directory for configuration file and retrieved feeds. Default is `$HOME/.jonesy`.
  - `$JONESY_HOST` — host address on which Jonesy will accept requests. Default is `127.0.0.1`.
  - `$JONESY_PORT` — port on which Jonesy will accept requests. Default is `8600`.

### Files and Directories

  - `$JONESY_HOME/jonesyrc` — file for configuration and feeds list.
  - `$JONESY_HOME/jonesyfeeds` — directory for retrieved feeds files.

#### `jonesyrc` Syntax

This is actually classic [curlrc](https://ec.haxx.se/cmdline-configfile.html) file, but for feeds list primarily. Its syntax is very simple:

```
  # This is a comment
  option = "value"
  boolean-option
```

One should define feeds by url/output pair, like so:

```
  url    = "https://news.ycombinator.com/rss"
  output = "hackernews.feed"

  url    = "https://blog.mozilla.org/feed"
  output = "mozilla.feed"

  # And so on...
```

In example above, `url` defines original feed URL and `output` defines local XML file which external reader application will access to. That is `output` feeds will be available at http://127.0.0.1/jonesyfeeds/ or http://example.org/jonesyfeeds/ for remote host.

See also: [jonesyrc example](examples/jonesyrc).

## Bugs and Issues

Some webmasters forbids their sites for automatic crawlers, which makes Jonesy (as cURL user) unable to retrieve feeds. To avoid this, one should manually set a user agent for something human-like:

```
  user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0"
```

Some feed URLs actually redirects to another location, which makes Jonesy unable to download them. To follow URL redirection, one should use `location` boolean option in jonesyrc:

```
  location
```

## TODO

  - [ ] Remove shell dependency
  - [ ] Remove cURL dependency
    - [ ] Replace curlrc by own config with same syntax
