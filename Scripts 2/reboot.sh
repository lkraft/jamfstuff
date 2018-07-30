#!/bin/sh

if test ! -f /usr/local/rebootdone
    then
      sudo touch /usr/local/rebootdone
      reboot
else
exit 0
fi
