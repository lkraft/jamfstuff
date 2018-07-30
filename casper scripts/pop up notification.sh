#!/bin/bash
#borrowed from rtrouton_scripts on git
#lkraft
#4/29/2016

# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

dialog="This is a test notification to see what happens for Addie"
description=`echo "$dialog"`
button1="OK"
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"

if [[ ${osvers} -lt 7 ]]; then

  "$jamfHelper" -windowType utility -description "$description" -button1 "$button1" -icon "$icon"

fi

if [[ ${osvers} -ge 7 ]]; then

  jamf displayMessage -message "$dialog"

fi

exit 0