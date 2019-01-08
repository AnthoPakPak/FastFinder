
# FastFinder

[![Join the chat at https://gitter.im/AnthoPakPak-FastFinder/community](https://badges.gitter.im/AnthoPakPak-FastFinder/community.svg)](https://gitter.im/AnthoPakPak-FastFinder/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

FastFinder goal is to always have a Finder window at a key press. Set your preferred shortcut, and use it to open your Finder window. The same window will be opened no matter on which Space you are !

**FastFinder is fully compatible with MacOS Mojave and compliant with System Integrity Protection, so that you don't have to disable it.**

![FastFinder Demo](FastFinderDemo.gif)


## How to use

<img src="https://i.imgur.com/rrAeThK.png" width="500">

- Download the [last version of FastFinder](https://github.com/AnthoPakPak/FastFinder/releases/download/0.1.1/FastFinder_v0.1.1.dmg)
- Drag it into your Applications folder
- Launch it and set your shortcut and settings
- If you are working with multiple Spaces, right click on Finder dock icon > `Options` > tick `All desktops` (I was unable to set it automatically currently, due to MacOS restrictions)


## How it works

FastFinder is written in `Objective-C` and is a standalone app. It listens for shortcut to bring your Finder. When you trigger the shortcut, it will find your Finder window and bring it to the front. It saves this Finder window `id` in order to always present the same window, even if you have multiple Finder windows opened. Basically, if Finder is not on screen, it shows it, and if it is, it hides it.


## Changelog

- **0.1.1**
**Support for multiple tabs in Finder window** : the last opened tab in your main Finder window will be reopened. Since `AppleScript` doesn't provide informations regarding if the window is a tab part of a window or if it's a main window (everything is a window), I've made the choice to detect if it's a tab by comparing window bounds. It works well, but it may be improved.
**Temporarily disable Launch At Startup feature** : disabled this setting and explained how to do it manually, since it is inexplicably long to implement in a Cocoa app. If you have time, feel free to submit a PR with the feature ;) (here is a good link to start with https://theswiftdev.com/2017/10/27/how-to-launch-a-macos-app-at-login/).

- **0.1**
Initial release


## Limitations

In order to comply with SIP protection, FastFinder is working with `AppleScript` only (`ScriptingBridge` to be precise). This means that it doesn't inject any code into Finder. Therefore, the capabilities of FastFinder are quite limited.

The sliding animation is experimental and you can see some quick glitches in some cases. This is due to how MacOS behaves with hidden windows.

Also note that it won't work on fullscreen Spaces, as it will switch to an non-fullscreen Space.


## Contribution

If you find better ways to implement this, or find workarounds to fix animations glitches, please feel free to make a PR or add a new issue with your code if you're lazy for the PR ;) 


## Licence
FastFinder is licensed under the GNU GPLv3 licence.
