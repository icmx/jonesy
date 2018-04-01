# Jonesy

Jonesy is extremely minimalistic aggregator for RSS, Atom and other web feeds. It works between user's reader application and original feed source which allows to synchronise feeds list for multiple devices and save original reader application experience.

One should consider that Jonesy is more of an idea than real software which is actually pretty crappy.

## Setup

Jonesy depends only on Python 3 and its standard library components. All you need is just get latest version from git:

```sh
  git clone "https://github.com/icmx/jonesy" "local-repo"
```

Once obtained, modify your [`$PATH`](https://en.wikipedia.org/wiki/PATH_(variable)) variable by adding local-repo/bin directory — or create a symlink to local-repo/bin/jonesy.

Finally, run Jonesy in setup mode:

```sh
  jonesy setup
```

This will create sample configuration in default directories — however one can override the defaults by modifying [environment variables](#environment-variables).

## Usage

### Modes

One can start Jonesy in three modes:

  - `jonesy setup` — single-shot, creates example configuration as explained above
  - `jonesy fetch` — another single-shot, obtains feeds from sources defined in config file
  - `jonesy serve` — runs until canceled, this mode serves retrieved feeds for external reader application (127.0.0.1 port 8600 by default).

### External Readers Connection

To use Jonesy, one should connect an external application to Jonesy's feeds. Suppose you have only one feed in your config file:

```xml
  <feed source="http://example.org/rss" result="news.feed" />
```

Be default reader application connects to original feed URL — http://example.org/rss, but since Jonesy retrieves and serves feeds locally, you have to use local feed link instead — http://127.0.0.1:8600/feeds/news.feed. Note the path: `news.feed` is actually result file previously specified in config.

Replace 127.0.0.1 by external address, e.g. http://example.org:8600/feeds/news.feed if you run Jonesy on external host (like on home server).

### Automatic Feed Updates

Jonesy is unable to update local feeds automatically. You have to do that manually or set up a recurrent job by at, Cron, systemd or other suitable for your system. That job should just execute `jonesy fetch` from time to time in a way you like it.

If you don't like to set up scheduler or your system have no any, there is a backup plan: one should access to special URL that will signal Jonesy to update its feeds:

> http://127.0.0.1:8600/fetch

Or, if Jonesy is serving on another host:

> http://example.org:8600/fetch

This URL provides a single-entry feed which should be placed at the top of external reader application feeds list. That is application will first ask Jonesy to update local feeds and then it will download them. Unfortunately this won't work if reader application updates feeds in multiple threads.

## Configuration

### Environment Variables

  - `$JONESY_HOME` — directory for configuration file and retrieved feeds. Default is `$HOME/.jonesy`.
  - `$JONESY_HOST` — host address on which Jonesy will accept requests. Default is `127.0.0.1`.
  - `$JONESY_PORT` — port on which Jonesy will accept requests. Default is `8600`.
  - `$JONESY_BUAS` — browser user agent string. By default Jonesy trying to disguise itself as a Firefox ESR, so feeds web servers will treat it as a human user.

### Files and Directories

  - `$JONESY_HOME/config.muon` — file for configuration and feeds list.
  - `$JONESY_HOME/feeds` — directory for retrieved feeds files.

#### Configuration Syntax

Jonesy reads XML configuration in Muon format which looks like this:

```xml
  <?xml version="1.0" encoding="utf-8"?>
  <muon version="1.0">
    <head>
    </head>
    <body>
      <feeds>
        <feed enabled="true" source="https://news.ycombinator.com/rss" result="yc.feed" />
        <!-- and so on ... -->
      </feeds>
    </body>
  </muon>
```

> Muon specs are currently in early development and available [here](https://github.com/icmx/muon).

##### Note for `&`s

Some feeds URLs contains ampersand characters **`&`**, for instance:

```
  http://example.org/get?news&type=rss"
                             ^ here
```

In XML `&`s must be replaced by `&amp;`, like so:

```xml
  <feed source="http://example.org/get?news&amp;type=rss"" result="news.feed" />
  <!--                                     ^^^^^ here                        -->
```

See also: [Jonesy config example](examples/config.muon).

## TODO

  - [x] Remove shell dependency
  - [x] Remove cURL dependency
    - [x] Replace curlrc by own config
  - [ ] Support `enabled` attribute in `<feed>` element
  - [ ] Add handling for `/` and `/config` paths in serve mode
  - [ ] Public Muon document specification
  - [ ] Clean code style
  - [ ] Avoid `xml.dom` and try to use something other instead
