#!/bin/bash

###
#
#            Name:  clover_clean_up_users.sh
#     Description:  Removes extraneous users from the /Users folder that may
#                   have been created by a bad Composer package.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-23
#   Last Modified:  2016-03-23
#         Version:  1.0
#
###

# If the /Users/lisakraft folder exists, but does not contain a Desktop folder,
# then this is not a real home folder and should be removed.
if [[ -d "/Users/lisakraft" && ! -d "/Users/lisakraft/Desktop" ]]; then
    rm -rf "/Users/lisakraft"
fi
