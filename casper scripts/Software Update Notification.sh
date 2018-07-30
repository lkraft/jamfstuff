#!/bin/bash

###
#
#            Name:  Software Update Notification.sh
#     Description:  pops up a notification to instruct users to upgrade to the latest OS.
#          Author:  lisa kraft  <lisa.kraft@cloverhealth.com>
#         Created:  2017-03-05
#   Last Modified:  2017-03-08
#         Version:  1.1
#
###

MSG_RESTART="Please upgrade your software to macOS Sierra.

Please contact IT in the support requests queue in yammer if you have questions or require assistance!

Thank you"

MSG_RESTART_HEADING="Software Upgrade Required!"

LOGO="/Library/CloverIT/Clover_Logo_White_RGB_Small_512px.png"

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType "hud" -icon "$LOGO" -heading "$MSG_RESTART_HEADING" -description "$MSG_RESTART" -iconSize "250"