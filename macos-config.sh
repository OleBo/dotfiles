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

##############################################################################
# Menubar                                                                    #
##############################################################################

# Disable transparency in the menu bar and elsewhere on Yosemite
#defaults write com.apple.universalaccess reduceTransparency -bool true

# Enable input menu in menu bar.
defaults write com.apple.TextInputMenu visible -bool true
defaults write com.apple.TextInputMenuAgent "NSStatusItem Visible Item-0" -bool true

# Menu bar: hide the User icon
defaults -currentHost write dontAutoLoad -array \
        "/System/Library/CoreServices/Menu Extras/User.menu"
defaults write com.apple.systemuiserver menuExtras -array \
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
        "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
        "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
        "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
        "/System/Library/CoreServices/Menu Extras/Volume.menu" \
        "/System/Library/CoreServices/Menu Extras/Battery.menu" \
        "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Autohide dock and menubar.
#defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Enable the dark menubar and dock.
#defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Disable Notification Center and remove the menu bar icon
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

##############################################################################
# Security                                                                   #
##############################################################################
# Also see: https://github.com/drduh/macOS-Security-and-Privacy-Guide
# https://benchmarks.cisecurity.org/tools2/osx/CIS_Apple_OSX_10.12_Benchmark_v1.0.0.pdf

# Enable Firewall. Possible values: 0 = off, 1 = on for specific sevices, 2 =
# on for essential services.
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable stealth mode
# https://support.apple.com/kb/PH18642
#sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true

# Enable firewall logging
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Do not automatically allow signed software to receive incoming connections
sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Reload the firewall
# (uncomment if above is not commented out)
launchctl unload /System/Library/LaunchAgents/com.apple.alf.useragent.plist
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.alf.agent.plist
sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist

# Apply configuration on all network interfaces.
IFS=$'\n'
for net_service in `networksetup -listallnetworkservices | awk '{if(NR>1)print}'`; do
    # Use Cloudflare's fast and privacy friendly DNS.
    networksetup -setdnsservers "${net_service}" 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
    # Clear out all search domains.
    networksetup -setsearchdomains "${net_service}" "Empty"
done
unset IFS

# Setup 10G NIC
#networksetup -setMTU "Thunderbolt Ethernet Slot  1, Port 2" 9000

# Disable IR remote control
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false

# Turn Bluetooth off completely
#sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
#sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
#sudo launchctl load /System/Library/LaunchDaemons/com.apple.blued.plist

# Disable wifi captive portal
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false

# Disable remote apple events
sudo systemsetup -setremoteappleevents off

# Disable remote login
# TODO: is waiting for user input. Make it unattended.
#sudo systemsetup -setremotelogin off

# Disable wake-on modem
sudo systemsetup -setwakeonmodem off
sudo pmset -a ring 0

# Disable wake-on LAN
sudo systemsetup -setwakeonnetworkaccess off
sudo pmset -a womp 0

# Disable file-sharing via AFP or SMB
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist

# Display login window as name and password
#sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Do not show password hints
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

# Disable guest account login
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Disable automatic login
sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser &> /dev/null

# A lost machine might be lucky and stumble upon a Good Samaritan.
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText \
    "Found this computer? Please contact me at olaf.bochmann@gmail.com or +49 159 03784736."

# Automatically lock the login keychain for inactivity after 6 hours.
security set-keychain-settings -t 21600 -l "${HOME}/Library/Keychains/login.keychain"

# Destroy FileVault key when going into standby mode, forcing a re-auth.
# Source: https://web.archive.org/web/20160114141929/https://training.apple.com/pdf/WP_FileVault2.pdf
sudo pmset destroyfvkeyonstandby 1

# Enable FileVault (if not already enabled)
# This requires a user password, and outputs a recovery key that should be
# copied to a secure location
if [[ $(sudo fdesetup status | head -1) == "FileVault is Off." ]]; then
  sudo fdesetup enable -user `whoami`
fi

# Disable automatic login when FileVault is enabled
#sudo defaults write /Library/Preferences/com.apple.loginwindow DisableFDEAutoLogin -bool true

# Enable secure virtual memory
sudo defaults write /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap -bool true

# Disable Bonjour multicast advertisements
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Disable diagnostic reports.
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.SubmitDiagInfo.plist

# Show location icon in menu bar when System Services request your location.
sudo defaults write /Library/Preferences/com.apple.locationmenu.plist ShowSystemServices -bool true

# Log firewall events for 90 days.
sudo perl -p -i -e 's/rotate=seq compress file_max=5M all_max=50M/rotate=utc compress file_max=5M ttl=90/g' "/etc/asl.conf"
sudo perl -p -i -e 's/appfirewall.log file_max=5M all_max=50M/appfirewall.log rotate=utc compress file_max=5M ttl=90/g' "/etc/asl.conf"

# Log authentication events for 90 days.
sudo perl -p -i -e 's/rotate=seq file_max=5M all_max=20M/rotate=utc file_max=5M ttl=90/g' "/etc/asl/com.apple.authd"

# Log installation events for a year.
sudo perl -p -i -e 's/format=bsd/format=bsd mode=0640 rotate=utc compress file_max=5M ttl=365/g' "/etc/asl/com.apple.install"

# Increase the retention time for system.log and secure.log (CIS Requirement 1.7.1I)
sudo perl -p -i -e 's/\/var\/log\/wtmp.*$/\/var\/log\/wtmp   \t\t\t640\ \ 31\    *\t\@hh24\ \J/g' "/etc/newsyslog.conf"

# CIS 3.3 audit_control flags setting.
sudo perl -p -i -e 's|flags:lo,aa|flags:lo,aa,ad,fd,fm,-all,^-fa,^-fc,^-cl|g' /private/etc/security/audit_control
sudo perl -p -i -e 's|filesz:2M|filesz:10M|g' /private/etc/security/audit_control
sudo perl -p -i -e 's|expire-after:10M|expire-after: 30d |g' /private/etc/security/audit_control

