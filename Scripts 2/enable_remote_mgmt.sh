#!/bin/sh

#Enable ssh
sudo /usr/sbin/systemsetup -setremotelogin on

#Setup ssh group
/usr/sbin/dseditgroup -o create -q com.apple.access_ssh

#Add local fc account to ssh group
/usr/sbin/dseditgroup -o edit -a fcadmin com.apple.access_ssh

#Enable Remote screen
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -specifiedUsers -restart -agent
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -users fcadmin -access -on -privs -all -restart -agent

exit 0
