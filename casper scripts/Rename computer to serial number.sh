#!/bin/bash

###
#
#            Name:  clover_set_computer_name.sh
#     Description:  Sets the computer name based on Clover standard.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-16
#   Last Modified:  2016-03-16
#         Version:  1.0.1
#
###

# Locate the jamf binary.
PATH="/usr/sbin:/usr/local/bin:$PATH"
jamf=$(which jamf)
if [[ -z $jamf ]]; then
    echo "[ERROR] The jamf binary could not be found."
    exit 1
fi

# Get serial number.
SERIAL_NUMBER="$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')"

# Set hostname.
if [[ -n $SERIAL_NUMBER ]]; then
    scutil --set ComputerName "ch-$SERIAL_NUMBER"
    scutil --set HostName "ch-$SERIAL_NUMBER"
    scutil --set LocalHostName "ch-$SERIAL_NUMBER"
    $jamf setComputerName -useSerialNumber -prefix "ch-"
else
    echo "Unable to determine serial number."
    exit 2
fi

exit 0