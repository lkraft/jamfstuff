#!/bin/sh

host=`hostname`

uname=`last | cut -f 1 -d ‘ ‘ | sort | uniq -c | sort -nr | awk ‘{print $2}’ | head -1`

owner=`dscl . -read /Users/$uname | grep -A1 “RealName” | tail -1`

pubip=`curl -s http://myip.dk/ | egrep -m1 -o ‘[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}’`

echo “The computer $host has come back online after being reported missing. \n\nThis computer is registered to $owner. \n\nThe external facing IP address this machine is broadcasting from is $pubip.” > /Library/Application\ Support/JAMF/missing.txt;

mail -s “Missing computer $host is active” cloverit@cloverhealth.com < /Library/Application\ Support/JAMF/missing.txt;rm -rf /Library/Application\ Support/JAMF/missing.txt;