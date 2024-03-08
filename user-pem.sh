#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Check if username argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Assign username from command-line argument
username=$1


# Check if the user already exists
getent passwd "$username"
# Check the exit status of the previous command
if [ $? -eq 0 ]; then
    echo "User '$username' already exists"
    exit 1
fi

# Create the user
useradd -m -s /bin/bash -d/home/"$username" "$username"
filename=/home/"$username"/"$username"

# Generate SSH keys for the user
sudo -u "$username" ssh-keygen -q -t rsa -b 4096 -N "" -f $filename -C ""
sudo -u "$username" mkdir /home/$username/.ssh
sudo -u "$username" touch /home/$username/.ssh/authorized_keys
sudo -u "$username" cat /home/$username/$username.pub >> /home/$username/.ssh/authorized_keys
echo ""
echo "----------------------------------------------------------------------"
echo "Share the following Private Key to the user"
echo "----------------------------------------------------------------------"
echo ""
cat $filename
echo ""
echo "----------------------------------------------------------------------"

echo "User '$username' created successfully with SSH keys"

exit 0

