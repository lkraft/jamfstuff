#!/bin/sh

# start here
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -int 1
sudo defaults write /Library/Preferences/com.apple.screensaver idleTime -int 300

mv /Applications/com.apple.screensaver.plist /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/
chown root:wheel /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver.plist
chmod 700 /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver.plist


exit 0
