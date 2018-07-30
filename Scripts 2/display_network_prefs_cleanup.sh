#!/bin/sh

# start here
sudo rm /Library/Preferences/com.apple.windowserver.plist

sudo defaults delete /Library/Preferences/SystemConfiguration/preferences NetworkServices
sudo defaults delete /Library/Preferences/SystemConfiguration/preferences CurrentSet
sudo defaults delete /Library/Preferences/SystemConfiguration/preferences Sets
sudo chmod 644 /Library/Preferences/SystemConfiguration/preferences.plist
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist

exit 0
