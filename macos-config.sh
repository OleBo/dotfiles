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

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Transform "  |   "model" = <"MacBookAir8,1">" to "MBA"
COMPUTER_MODEL_SHORTHAND=$(ioreg -c IOPlatformExpertDevice -d 2 -r | grep "model" | python -c "print(''.join([c for c in input() if c.isupper()]))")
COMPUTER_NAME="$(whoami)-${COMPUTER_MODEL_SHORTHAND}"
# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "${COMPUTER_NAME}"
sudo scutil --set HostName "${COMPUTER_NAME}"
sudo scutil --set LocalHostName "${COMPUTER_NAME}"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${COMPUTER_NAME}"

# Increase limit of open files.
sudo tee -a /etc/sysctl.conf <<-EOF
kern.maxfiles=20480
kern.maxfilesperproc=18000
EOF

# Remove default content
rm -rf "${HOME}/Downloads/About Downloads.lpdf"
rm -rf "${HOME}/Public/Drop Box"
rm -rf "${HOME}/Public/.com.apple.timemachine.supported"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Enable ctrl+option+cmd to drag windows.
defaults write com.apple.universalaccess NSWindowShouldDragOnGesture -string "YES"

# Set highlight color to green
#defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# Enable graphite appearance.
#defaults write NSGlobalDomain AppleAquaColorVariant -int 6

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
#defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# Disable the over-the-top focus ring animation
#defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Ask to keep changes when closing documents
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true

# Don't keep recent items for Documents, Apps and Servers.
#osascript << EOF
#  tell application "System Events"
#    tell appearance preferences
#      set recent documents limit to 0
#      set recent applications limit to 0
#      set recent servers limit to 0
#    end tell
#  end tell
#EOF

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
#defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
#defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Keep all windows open from previous session.
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool true

# Disable automatic termination of inactive apps
#defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
#defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo -string "HostName"

# Restart automatically if the computer freezes
#sudo systemsetup -setrestartfreeze on

# Disable automatic capitalization as it’s annoying when typing code
#defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
#defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
#defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
#defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
#defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf "${HOME}/Library/Application Support/Dock/desktoppicture.db"
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

# Play user interface sound effects
defaults write -globalDomain "com.apple.sound.uiaudio.enabled" -int 0

# Play feedback when volume is changed
defaults write -globalDomain "com.apple.sound.beep.feedback" -int 0
