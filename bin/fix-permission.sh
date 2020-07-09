#!/bin/bash

set -e


#####################################
# Fix the filesystem permissions for the magento root.
# Arguments:
#   None
# Returns:
#   None
#####################################
function fixFilesystemPermissions() {
	chmod -R go+rw /var/www/html/web
}

#####################################
# A never-ending while loop (which keeps the installer container alive)
# Arguments:
#   None
# Returns:
#   None
#####################################
function runForever() {
	while :
	do
		sleep 1
	done
}

# Fix the www-folder permissions
chgrp -R 33 /var/www/html
chgrp -R 33 /bin


# Check if the specified MAGENTO_ROOT direcotry exists
if [ ! -d "/var/www/html/web" ]
then
	echo "The OpenMage source directory does not exist."
	exit 1
fi


chgrp -R 33 /var/www/html/web


echo "Fixing filesystem permissions"
fixFilesystemPermissions

runForever
exit 0
