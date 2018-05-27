# Jonesy

Jonesy is an extremely minimalistic aggregator for RSS, Atom and other web feeds. It works between users' reader application and original feed source which allows to share and synchronise the single feeds list by multiple devices and save original reader application experience.

One should consider that Jonesy is more of an idea than real software which is actually pretty crappy.

## Setup

Jonesy depends only on Python 3 and its standard components. All you need is just get latest version from git repository:

```sh
git clone "https://github.com/icmx/jonesy" "local-copy"
```

Then make the following:

```sh
cd local-copy

mkdir -p $XDG_CONFIG_HOME/jonesy/feeds
cp       examples/feeds.muon $XDG_CONFIG_HOME/jonesy/
```

Jonesy assumes that you have [XDG base directories](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) defined in environment variables. If such variables aren't set, it will use *~/.jonesy* as a fallback.

## Usage

### Modes

One can start Jonesy in three modes:

  - `jonesy fetch` — single-shot, obtains feeds from sources defined in config file
  - `jonesy serve` — runs until cancelled, this mode serves retrieved feeds for external reader application (127.0.0.1 port 8600 by default).

### External Readers Connection

To use Jonesy, one should connect an external application to Jonesy's feeds. Suppose one have the following feed in config file:

```xml
<feed source="http://example.org/rss" result="news.feed" />
```

By default reader application connects to original feed URL — http://example.org/rss, but since Jonesy retrieves and serves feeds locally, reader should use local feed link instead — http://127.0.0.1:8600/feeds/news.feed. Note the path: `news.feed` is actually result file previously specified in config.

Replace 127.0.0.1 by external address, e.g. http://example.org:8600/feeds/news.feed if you run Jonesy on external host (like on home server).

### Automatic Feed Updates

Jonesy is unable to update local feeds automatically. You have to do that manually or set up a recurrent job by *at*, *Cron*, *systemd* or other suitable scheduler for your system. That job should just execute `jonesy fetch` from time to time in a way you like it.

If you don't like to set up scheduler or your system have no any, there is a backup plan: reader should access to special URL that will signal Jonesy to update its feeds:

> http://127.0.0.1:8600/fetch

Or, if Jonesy is serving on another host:

> http://example.org:8600/fetch

This URL provides a single-entry feed which should be placed at the top of reader application feeds list. That is application will first ask Jonesy to update local feeds and then it will download them. Unfortunately this won't work if reader application updates feeds in multiple threads.

*See also: [updater script](examples/updater.sh)*

## Configuration

Jonesy is a simple application and thus relies only on environment variables and feeds list defined in Muon file.

### Environment Variables

  - `$JONESY_HOME` — directory for feeds list and retrieved items. If `$XDG_CONFIG_HOME` is defined, then it will be assumed as `$XDG_CONFIG_HOME/jonesy`, or `~/.jonesy` otherwise.
  - `$JONESY_HOST` — address on which Jonesy will host local feeds, 127.0.0.1 by default.
  - `$JONESY_PORT` — port, 8600 by default
  - `$JONESY_USERAGENT` — "Browser" user agent string. By default Jonesy is trying to disguise itself as a Firefox, so feeds web servers will treat it as a human user.
  - `$JONESY_THREADS` — number of threads which will fetch feed items, 4 by default.
  - `$JONESY_MODE` — parsing mode, support only these values:
    - `muon`: parse Muon feeds file (*feeds.muon*) — default
    - `opml`: parse OPML subscriptions flat list (*feeds.opml*)

### Files and Directories

  - `$JONESY_HOME/feeds` — directory for retrieved feeds files.
  - `$JONESY_HOME/feeds.$JONESY_MODE` — file for feeds list, depends on `$JONESY_MODE` defined. By default it's *feeds.muon*.

*Notes:*

  - Muon specification is currently in early development and available [here](https://github.com/icmx/muon).
  - Classic OPML specification is available [here](http://dev.opml.org/spec2.html)

#### Note for Ampersand Characters

Some feeds URLs contains ampersand characters `&`, for instance:

```
http://example.org/get?news&type=rss"
                           ^ this
```

Your feeds list (as well as other XML files) should avoid ampersands and replace them by special escape sequence `&amp;`, like so:

```xml
<feed source="http://example.org/get?news&amp;type=rss" result="news.feed" />
<!--                                     ^^^^^ this                       -->
```

## TODO

### For Current

  - [x] Remove shell dependency
  - [x] Remove cURL dependency
    - [x] Replace curlrc by own config
  - [x] Support `enabled` attribute in `<feed>` element
  - [x] Add handling for `/` ~~and `/config`~~ paths in serve mode
  - [x] Public Muon document specification
  - [x] Avoid `xml.dom` and try to use something other instead
  - [x] Add timestamps to logging
  - [x] Add handling for web errors
  - [x] Make it multithreaded
  - [x] Remove config and its parsing
  - [x] Add `$JONESY_THREADS` setting (number of threads used in fetch mode)
  - [x] Rewrite utility classes
  - [x] Add parsing in multiple modes (for Muon and OPML)
    - [x] Add `$JONESY_MODE` setting (comptibility mode for OPML feeds list)
  - [ ] Add 404 page (for not existing feeds e.g.)
  - [ ] Add optional feeds listing
  - [ ] Add first-launch self-configuration
  - [ ] Rewrite dirty sections
  - [ ] Move to the Jonesy NG version

### For Jonesy NG

  - [ ] Make it socket-based
  - [ ] Add basic sanitizer functions (e.g. image to base64)
  - [ ] Add basic web-interface
    - [ ] Static page
    - [ ] Javascript JSON parsers and page builders
  - [ ] Design basic API
