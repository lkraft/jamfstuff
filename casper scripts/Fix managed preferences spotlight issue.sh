#!/bin/bash


##
# Spotlight: Fix managed preferences spotlight issue
##
if [ -e /Library/Managed\ Preferences/*Spotlight* ]; then echo "System: Spotlight Managed Pref Plist found.  Removing..."; rm -rf /Library/Managed\ Preferences/*Spotlight*; killall Spotlight; fi
if [ -e /Library/Managed\ Preferences/*/*Spotlight* ]; then echo "System: Spotlight Managed Pref Plist found.  Removing..."; rm -rf /Library/Managed\ Preferences/*/*Spotlight*; killall Spotlight; fi