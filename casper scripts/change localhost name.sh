#!/bin/sh

SETNAME=`scutil --get LocalHostName`

jamf setcomputername -name $SETNAME

exit 0