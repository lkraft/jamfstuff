#!/bin/bash

###
#
#            Name:  clover_clamxav_config.sh
#     Description:  Script that runs after ClamXav installation and ensures
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-22
#   Last Modified:  2016-03-23
#         Version:  1.0.3
#
###

echo "Determining current user..."
CURRENT_USER=$(/usr/bin/stat -f%Su /dev/console)
CLAMXAV_PREFS="/Users/$CURRENT_USER/Library/Preferences/uk.co.canimaansoftware.clamxav.plist"
SENTRY_PREFS="/Users/$CURRENT_USER/Library/Preferences/uk.co.canimaansoftware.clamxav.ClamXav-Sentry.plist"

echo "Determining OS version..."
OS_MAJOR=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}')
OS_MINOR=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $2}')

if [[ $CURRENT_USER == "root" || $CURRENT_USER == "" ]]; then
    echo "[ERROR] No user logged in."
    exit 1
fi

if [[ ! -d "/Applications/ClamXav.app" ]]; then
    echo "[ERROR] ClamXav is not installed."
    exit 2
fi

if pgrep -i "clam" &>/dev/null; then
    echo "ClamXav is already running. Stopping processes and apps..."
    sudo killall "ClamXav Sentry"
    sudo killall "ClamXav"
    sudo killall clamd
fi

if [[ -f "$CLAMXAV_PREFS" ]]; then
    echo "ClamXav preferences already exist. Removing preferences..."
    rm -f "$CLAMXAV_PREFS"
fi

if [[ -f "$SENTRY_PREFS" ]]; then
    echo "ClamXav Sentry preferences already exist. Removing preferences..."
    rm -f "$SENTRY_PREFS"
fi

echo "Setting ClamXav Sentry as a login item for $CURRENT_USER..."
APPLESCRIPT='tell application "System Events" to make new login item at end with properties { path:"/Applications/ClamXav.app/Contents/Resources/ClamXav Sentry.app", name:"ClamXav Sentry.app", hidden:false }'
su -l "$CURRENT_USER" -c "osascript -e '$APPLESCRIPT'"

echo "Setting ClamXav preferences for $CURRENT_USER..."
cat << EOF > "$CLAMXAV_PREFS"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Last Successful Defs Update</key>
	<date>2016-01-01T00:00:00Z</date>
	<key>LaunchSentryAtLogin</key>
	<true/>
	<key>NeedsExit1FreshclamFlag</key>
	<true/>
	<key>PathToClamav</key>
	<string>/usr/local/clamXav</string>
	<key>PathToUpdateLog</key>
	<string>/usr/local/clamXav/share/clamav/freshclam.log</string>
	<key>Preferences Transitioned</key>
	<true/>
	<key>SUEnableAutomaticChecks</key>
	<true/>
	<key>SUHasLaunchedBefore</key>
	<true/>
	<key>SULastCheckTime</key>
	<date>2016-01-01T00:00:00Z</date>
	<key>SULastProfileSubmissionDate</key>
	<date>2016-01-01T00:00:00Z</date>
	<key>SUSendProfileInfo</key>
	<true/>
	<key>ScheduleUpdateTime</key>
	<date>2001-01-01T18:00:00Z</date>
	<key>ScheduledUpdateDays</key>
	<integer>3</integer>
	<key>SentryFolderArray</key>
	<array>
		<dict>
			<key>WatchSubdirs</key>
			<true/>
			<key>pathName</key>
			<string>~</string>
		</dict>
	</array>
	<key>SentryIgnoreNetworkVolumes</key>
	<true/>
	<key>SentryQuarantineFiles</key>
	<false/>
	<key>SentryScanVolumes</key>
	<false/>
	<key>UpdateDefsOnLaunch</key>
	<true/>
	<key>User Accepted ClamXav EULA v20150918</key>
	<date>2016-01-01T00:00:00Z</date>
	<key>infectionListContents</key>
	<array/>
</dict>
</plist>
EOF

echo "Setting ClamXav Sentry preferences for $CURRENT_USER..."
cat << EOF > "$SENTRY_PREFS"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PathToClamav</key>
	<string>/usr/local/clamXav</string>
	<key>PathToUpdateLog</key>
	<string>/usr/local/clamXav/share/clamav/freshclam.log</string>
	<key>Preferences Transitioned</key>
	<true/>
	<key>SUEnableAutomaticChecks</key>
	<false/>
	<key>SULastCheckTime</key>
	<date>2016-01-01T00:00:00Z</date>
</dict>
</plist>
EOF

echo "Updating virus definitions..."
/usr/local/clamXav/bin/RunFreshclam

echo "Launching ClamXav Sentry..."
if [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -le 9 ]]; then
    CURRENT_USER_LOGIN_PID=$(ps auxww | grep "/System/Library/CoreServices/loginwindow.app/Contents/MacOS/loginwindow" | grep "$CURRENT_USER" | grep -v "grep" | awk '{print $2}')
    launchctl bsexec "$CURRENT_USER_LOGIN_PID" open "/Applications/ClamXav.app/Contents/Resources/ClamXav Sentry.app"
elif [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -gt 9 ]]; then
    CURRENT_USER_LOGIN_UID=$(id -u "$CURRENT_USER")
    launchctl asuser "$CURRENT_USER_LOGIN_UID" open "/Applications/ClamXav.app/Contents/Resources/ClamXav Sentry.app"
else
    echo "[ERROR] OS X $OS_MAJOR.$OS_MINOR is not supported. The user may need to logout or restart in order to launch the ClamXav Sentry."
    exit 3
fi

echo "All done."

exit 0
