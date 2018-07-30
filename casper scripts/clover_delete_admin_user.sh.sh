#!/bin/bash

###
#
#            Name:  clover_delete_admin_user.sh
#     Description:  Removes existing cloverit account, in preparation for
#                   creating a new cloverit account with an updated
#                   password.
#          Author:  Elliot Jordan <elliot@lindegroup.com>
#         Created:  2016-03-23
#   Last Modified:  2016-03-23
#         Version:  1.0
#
###

# Locate the jamf binary.
PATH="/usr/sbin:/usr/local/bin:$PATH"
jamf=$(which jamf)
if [[ -z $jamf ]]; then
    echo "[ERROR] The jamf binary could not be found."
    exit 1
fi

echo "Removing existing admin account..."
$jamf policy -event "delete-cloverit"

if [[ $? != 0 ]]; then
    echo "Failed to remove existing admin account. Aborting."
    exit 2
fi

exit 0
