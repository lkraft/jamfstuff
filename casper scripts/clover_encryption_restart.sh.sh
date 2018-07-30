#!/bin/bash

###
#
#            Name:  clover_encryption_restart.sh
#     Description:  This script prompts users to restart their Macs in order to
#                   initiate FileVault encryption.
#
#                   This version of the script utilizes a local
#                   script/LaunchDaemon pair to display the jamfHelper message.
#                   This prevents the message from being easily ignored or
#                   dismissed.
#
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-22
#   Last Modified:  2016-03-23
#         Version:  1.0.1
#
###


############################# PATHS AND VARIABLES ##############################

# The plist file that is used to store settings locally. Omit ".plist" extension.
CASPER_PLIST="/Library/CloverIT/com.cloverhealth.casper"

# The logo that will be used in messaging. Recommend 512px square, PNG format.
LOGO="/Library/CloverIT/Clover_Logo_White_RGB_Small_512px.png"
# LOGO="/Library/CloverIT/Clover_Logo_Green_RGB_Small_512px.png"
# LOGO="/Library/CloverIT/Clover_Logo_Black_RGB_Small_512px.png"

# Name of our local jamfHelper script.
HELPER_SCRIPT="clover_encryption_restart.sh"

# Name of our LaunchDaemon (including .plist extension).
LAUNCHDAEMON="com.cloverhealth.casper.encryption_restart.plist"

MSG_RESTART_HEADING="Restart required"
MSG_RESTART="In order to enable encryption, your computer needs to restart. Please save your work, quit open apps, and choose Restart from the Apple menu.

Enter your computer password when prompted."

# Shell executable paths.
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Locate the jamf binary.
PATH="/usr/sbin:/usr/local/bin:$PATH"
jamf=$(which jamf)

######################## VALIDATION AND ERROR CHECKING #########################


# Suppress errors for the duration of this script.
exec 2>/dev/null

# If the jamf binary or jamfHelper doesn't exist, bail out.
if [[ ! -x "$jamf" || ! -x "$jamfHelper" ]]; then
    echo "[ERROR] The jamf and jamfHelper binaries must be present in order to run this script."
    exit 2
fi

# We need the logo to be present in order to display messages.
if [[ ! -f "$LOGO" ]]; then
    echo "[WARNING] Logo file not present. Trying to install..."
    $jamf policy -trigger "clover-stash"
    if [[ ! -f "$LOGO" ]]; then
        echo "[ERROR] Logo file ($LOGO) doesn't exist and could not be installed."
        exit 3
    fi
fi

# If FileVault is already on, abort and clean up LaunchDaemon and script.
FILEVAULT_STATUS="$(/usr/bin/fdesetup status | grep "FileVault is ")"
if [[ "$FILEVAULT_STATUS" == "FileVault is On." ]]; then
    echo "FileVault is already on. No need to prompt for restart."
    rm -f "/tmp/$HELPER_SCRIPT"
    launchctl unload "/Library/LaunchDaemons/$LAUNCHDAEMON" &>/dev/null
    rm -f "/Library/LaunchDaemons/$LAUNCHDAEMON"
    killall jamfHelper
    exit 0
fi


################################# MAIN PROCESS #################################

# Close any existing jamfHelper windows.
launchctl unload "/Library/LaunchDaemons/$LAUNCHDAEMON" &>/dev/null
killall jamfHelper

# Create a jamfHelper script that will be called by a LaunchDaemon.
cat << EOF > "/tmp/$HELPER_SCRIPT"
#!/bin/bash
"$jamfHelper" -windowType "hud" -lockHUD -windowPosition "ur" -icon "$LOGO" -heading "$MSG_RESTART_HEADING" -description "$MSG_RESTART" -startlaunchd
EOF

chmod +x "/tmp/$HELPER_SCRIPT"

# Create the LaunchDaemon that calls the jamfHelper script.
cat << EOF > "/tmp/$LAUNCHDAEMON"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>Label</key>
        <string>$(echo "$LAUNCHDAEMON" | sed "s/.plist$//g")</string>
        <key>Program</key>
        <string>/tmp/$HELPER_SCRIPT</string>
        <key>KeepAlive</key>
        <true/>
    </dict>
</plist>
EOF

# Load the LaunchDaemon.
echo "Displaying \"please restart\" message..."
mv "/tmp/$LAUNCHDAEMON" "/Library/LaunchDaemons/" &>/dev/null
launchctl load "/Library/LaunchDaemons/$LAUNCHDAEMON" &>/dev/null

# If this is the first time encryption has been enforced, write a datestemp.
# We use this later to determine whether the Mac is more than 1 week out of compliance.
defaults read "$CASPER_PLIST" FirstEncryptionRestartPrompt &>/dev/null
if [[ $? -ne 0 ]]; then
    defaults write "$CASPER_PLIST" FirstEncryptionRestartPrompt -date "$(date -u)"
fi

exit 0
