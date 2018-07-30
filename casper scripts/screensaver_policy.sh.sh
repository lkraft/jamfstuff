#!/bin/bash

###
#
#            Name:  screensaver_policy.sh
#     Description:  This script sets the screensaver to run at 5 minutes idle,
#                   but only if the setting is not already 5 minutes or less.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2014-11-12
#   Last Modified:  2015-06-01
#         Version:  1.1.1
#
###

currentUser=$(/usr/bin/stat -f%Su /dev/console)

# idleTime is in seconds, and can be one of these values:
#        0 = Never
#       60 = 1 minute
#      120 = 2 minutes
#      ...etc...
#     3600 = 1 hour
if [[ -z $4 ]]; then
    defaultIdleTime=300 # Default to 5 minutes if unspecified
else
    defaultIdleTime=$4
fi
currentIdleTime=$(su -l "$currentUser" -c "/usr/bin/defaults -currentHost read com.apple.screensaver idleTime 2> /dev/null")
if [[ $? -ne 0 || $currentIdleTime -gt $defaultIdleTime || $currentIdleTime -eq 0 ]]; then
    echo "Setting idleTime to $defaultIdleTime..."
    su -l "$currentUser" -c "/usr/bin/defaults -currentHost write com.apple.screensaver idleTime $defaultIdleTime"
    if [[ $? -ne 0 ]]; then
        echo "    Error setting idleTime."
    else
        echo "    Successfully set idleTime."
    fi
else
    echo "idleTime already meets our requirements."
fi

# askForPassword can be one of these values:
#    1 (yes, require password)
#    0 (no, do not require password)
if [[ -z $5 ]]; then
    defaultAskForPassword=1 # Default to yes if unspecified
else
    defaultAskForPassword=$5
fi
currentAskForPassword=$(su -l "$currentUser" -c "/usr/bin/defaults read com.apple.screensaver askForPassword 2> /dev/null")
if [[ $? -ne 0 || $currentAskForPassword -ne $defaultAskForPassword ]]; then
    echo "Setting askForPassword to $defaultAskForPassword..."
    su -l "$currentUser" -c "/usr/bin/defaults write com.apple.screensaver askForPassword $defaultAskForPassword"
    if [[ $? -ne 0 ]]; then
        echo "    Error setting askForPassword."
    else
        echo "    Successfully set askForPassword."
    fi
else
    echo "defaultAskForPassword already meets our requirements."
fi

# askForPasswordDelay is the grace period between when the screensaver starts and when a password is required
#         0 = Require password immediately
#         5 = After 5 seconds
#        60 = After 1 minute
#       ...etc...
#     28800 = After 8 hours
if [[ -z $6 ]]; then
    defaultAskForPasswordDelay=0 # Default to immediately if unspecified
else
    defaultAskForPasswordDelay=$6
fi
currentAskForPasswordDelay=$(su -l "$currentUser" -c "/usr/bin/defaults read com.apple.screensaver askForPasswordDelay 2> /dev/null")
if [[ $? -ne 0 || $currentAskForPasswordDelay -gt $defaultAskForPasswordDelay ]]; then
    echo "Setting askForPasswordDelay to $defaultAskForPasswordDelay..."
    su -l "$currentUser" -c "/usr/bin/defaults write com.apple.screensaver askForPasswordDelay $defaultAskForPasswordDelay"
    if [[ $? -ne 0 ]]; then
        echo "    Error setting askForPasswordDelay."
    else
        echo "    Successfully set askForPasswordDelay."
    fi
else
    echo "defaultAskForPasswordDelay already meets our requirements."
fi

exit 0