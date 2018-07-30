#!/bin/sh

###
#
#            Name:  clover_enable_ssh.sh
#     Description:  Enables SSH access on Clover Health Macs.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-15
#   Last Modified:  2016-03-15
#         Version:  1.1
#
###

systemsetup -f -setremotelogin on

# Create the access_ssh group if it doesn't already exist
dseditgroup com.apple.access_ssh
if [[ $? -ne 0 ]]; then
    dseditgroup -o create -q com.apple.access_ssh
fi

# Add cloverit to the access_ssh group
dseditgroup -o edit -a cloverit -t user com.apple.access_ssh