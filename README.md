# FastFinder

FastFinder goal is to always have a Finder window at a key press. Set your preferred shortcut, and use it to open your Finder window. The same window will be opened no matter on which Space you are !

**FastFinder is fully compatible with MacOS Mojave and compliant with System Integrity Protection, so that you don't have to disable it.**

![FastFinder Demo](https://cdn-04.bayfiles.com/T5c052m6b7/c53ac742-1543705968/Demo+FastFinder.gif)


## How to use

- Download the [last version of FastFinder](https://github.com/AnthoPakPak/FastFinder/releases/download/0.1/FastFinder_v0.1.dmg)
- Drag it into your Applications folder
- Launch it and set your shortcut and settings
- If you are working with multiple Spaces, right click on Finder dock icon > `Options` > tick `All desktops` (I was unable to set it automatically currently, due to MacOS restrictions)


## How it works

FastFinder is written in `Objective-C` and is a standalone app. It listens for shortcut to bring your Finder. When you trigger the shortcut, it will find your Finder window and bring it to the front. It saves this Finder window `id` in order to always present the same window, even if you have multiple Finder windows opened. Basically, if Finder is not on screen, it shows it, and if it is, it hides it.

## Limitations

In order to comply with SIP protection, FastFinder is working with `AppleScript` only (`ScriptingBridge` to be precise). This means that it doesn't inject any code into Finder. Therefore, the capabilities of FastFinder are quite limited.

The sliding animation is experimental and you can see some quick glitches in some cases. This is due to how MacOS behaves with hidden windows.

Also note that it won't work on fullscreen Spaces, as it will switch to an non-fullscreen Space.

## Contribution

If you find better ways to implement this, or find workarounds to fix animations glitches, please feel free to make a PR or add a new issue with your code if you're lazy for the PR ;) 


## Licence
FastFinder is licensed under the GNU GPLv3 licence.
