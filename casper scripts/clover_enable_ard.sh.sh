#!/bin/sh

###
#
#            Name:  clover_enable_ard.sh
#     Description:  Enables Apple Remote Desktop on Clover Health Macs.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-15
#   Last Modified:  2016-03-15
#         Version:  1.0
#
###

/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users cloverit -privs -all -restart -agent
