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
