#!/bin/bash

###
#
#            Name:  clover_populate_user_info.sh
#     Description:  Populates the "primary user" in the JSS with the
#                   currently logged in username and building (office
#                   location) and performs an inventory update.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-15
#   Last Modified:  2016-03-16
#         Version:  1.1.2
#
###

# Determine logged-in username and full name.
CURRENT_USER=$(/usr/bin/stat -f%Su /dev/console)
REALNAME=$(dscl . -read "/Users/$CURRENT_USER" RealName | grep -v "RealName" | colrm 1 1)

# Get geographic coordinates of the computer's current network location.
# Note: ipinfo.io is limited to 1000 daily requests.
COORDS_FULL=$(curl -s "ipinfo.io/loc")
if [[ $? -eq 0 ]]; then
    # Parse output of ipinfo.io.
    COORDS_LAT=$(echo "$COORDS_FULL" | awk -F "," '{print $1}')
    COORDS_LON=$(echo "$COORDS_FULL" | awk -F "," '{print $2}')
else
    # ipinfo.io is not available, so fall back to whatismycountry.com.
    COORDS_FULL=$(curl -s "whatismycountry.com" | sed -n 's/.*Coordinates \(.*\)<.*/\1/p')
    COORDS_LAT=$(echo "$COORDS_FULL" | awk '{print $1}')
    COORDS_LON=$(echo "$COORDS_FULL" | awk '{print $2}')
fi

# Translate geographic coordinates to Clover Health office location.
if   (( $(bc <<< "$COORDS_LON < -120.0") == 1 )) &&
     (( $(bc <<< "$COORDS_LON > -124.0") == 1 )) &&
     (( $(bc <<< "$COORDS_LAT < 40.0") == 1 )) &&
     (( $(bc <<< "$COORDS_LAT > 36.0") == 1 )); then
    BUILDING="SF Office"
elif (( $(bc <<< "$COORDS_LON < -73.5") == 1 )) &&
     (( $(bc <<< "$COORDS_LON > -74.5") == 1 )) &&
     (( $(bc <<< "$COORDS_LAT < 41.5") == 1 )) &&
     (( $(bc <<< "$COORDS_LAT > 40.5") == 1 )); then
    BUILDING="NJ Office"
else
    BUILDING="Remote"
fi

# Populates the JSS with the current user and performs an inventory update.
jamf recon \
    -endUsername "$CURRENT_USER" \
    -realname "$REALNAME" \
    -building "$BUILDING"

exit $?