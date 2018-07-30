#!/bin/sh

MAC_SERIAL_NUMBER=`ioreg -l | grep IOPlatformSerialNumber|awk '{print $4}' | cut -d \" -f 2`

scutil --set LocalHostName "$MAC_SERIAL_NUMBER"

scutil --set ComputerName "$MAC_SERIAL_NUMBER"

scutil --set HostName "$MAC_SERIAL_NUMBER"


exit 0
