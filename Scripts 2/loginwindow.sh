#!/bin/sh

# start here
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool FALSE
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool TRUE
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -int 1
sudo defaults write /Library/Preferences/com.apple.screensaver idleTime -int 600

cp /usr/local/com.apple.screensaver* /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/

# Set Permissions on those preference files in User Template
chown root:wheel /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver*
chmod 700 /System/Library/User\ Template/English.lproj/Library/Preferences/ByHost/com.apple.screensaver*


exit 0
