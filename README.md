# OverPing

By [@nevyn](https://twitter.com/nevyn).

OverPing lets you continuously monitor the performance of your Internet connection. This is useful if you're on unreliable wifi or Hotspotting while travelling, as it lets you tell at a glance whether your current connectivity problems are your connection's fault or not.

For example, I keep this running while on the train and doing a Hangout or Slack voice chat. When the other side cuts out, I can look at the bars: if they're green, it's their connection that sucks; if they're not green, it's my connection.

Before OverPing, I would always have a Terminal window open on every desktop just doing `ping 8.8.8.8`. OverPing does this, but on every desktop, and with a pretty, animated bar graph. Each pixel represents one millisecond of delay in getting information to and from Internet.

<img width="569" alt="screenshot 2017-01-15 16 05 20" src="https://cloud.githubusercontent.com/assets/34791/21967457/89daab40-db3c-11e6-8feb-c52765fd4ee5.png">

# Installation and usage

1. [Download the latest OverPing release](https://github.com/nevyn/OverPing/releases/latest)
2. Unzip and drag it to your Applications folder (or wherever)
3. Double click to launch. Maybe add to your login items? :)

There are no configuration options.

# Version History

## v1.2

* Slightly modernized UI for macOS 26

## v1.1

* Apple Silicon and modern macOS support
* Notarized
* Thicker bars

## v1.0 (1)

* First release


# To-do

* Fix the bug where bars disappear when scrolling
* Exponential bars?
* Better visualization of error type
