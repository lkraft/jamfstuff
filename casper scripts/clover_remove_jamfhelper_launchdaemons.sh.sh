#!/bin/bash

###
#
#            Name:  clover_remove_jamfhelper_launchdaemons.sh
#     Description:  This script is meant to run at startup and remove
#                   the LaunchDaemons that Clover uses to display "please
#                   restart" prompts as part of certain Casper policies.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-23
#   Last Modified:  2016-03-23
#         Version:  1.0
#
###

# Paths of the LaunchDaemons to detect and remove.
LAUNCHDAEMONS=(
    "/Library/LaunchDaemons/com.cloverhealth.casper.encryption_restart.plist"
)

# Iterate through the above list. Unload and remove each LaunchDaemon.
for (( i = 0; i < ${#LAUNCHDAEMONS[@]}; i++ )); do
    if [[ -f "${LAUNCHDAEMONS[$i]}" ]]; then
        echo "Unloading and removing ${LAUNCHDAEMONS[$i]}..."
        launchctl unload "${LAUNCHDAEMONS[$i]}" 2>/dev/null
        rm -f "${LAUNCHDAEMONS[$i]}" 2>/dev/null
    fi
done

exit 0
