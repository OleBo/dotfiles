#!/usr/bin/env zsh
###############################################################################
# Plist and preferences                                                       #
###############################################################################
# There is a couple of plist editing tools:
#
#  * defaults
#    Triggers update notification update to running process, but usage is
#    tedious.
#
#  * /usr/libexec/PlistBuddy
#    Great for big update, can create non-existing files.
#
#  * plutil
#    Can manipulate arrays and dictionaries with key paths.
#
# Sources:
#   * https://scriptingosx.com/2016/11/editing-property-lists/
#   * https://scriptingosx.com/2018/02/defaults-the-plist-killer/
#   * https://apps.tempel.org/PrefsEditor/index.php

set -x

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Extract hardware UUID to reconstruct host-dependent plists.
HOST_UUID=$(ioreg -d2 -c IOPlatformExpertDevice | awk -F\" '/IOPlatformUUID/{print $(NF-1)}')

###############################################################################
# Permissions and Access                                                      #
###############################################################################

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Some plist preferences files are not readable either by the user or root
# unless the Terminal.app gets Full Disk Access permission.
#
# ❯ cat /Users/kde/Library/Preferences/com.apple.AddressBook.plist
# cat: /Users/kde/Library/Preferences/com.apple.AddressBook.plist: Operation not permitted
#
# ❯ sudo cat /Users/kde/Library/Preferences/com.apple.AddressBook.plist
# Password:
# cat: /Users/kde/Library/Preferences/com.apple.AddressBook.plist: Operation not permitted
# TODO: Add Full Disk Access to Terminal.app

# Add Terminal as a developer tool.
# Source: an Apple Xcode engineer at: https://news.ycombinator.com/item?id=23278629
sudo spctl developer-mode enable-terminal
# TODO: go to Security & Privacy preference pane, login and check Terminal app.
