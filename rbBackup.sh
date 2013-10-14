#! /bin/bash

# Descriprion:
# This simple script creates a local sd image backup of a remote raspberry pi in a local folder
# using ssh, dd, and the unix pipe

# Requirements:

# - ssh e sshpass
# - notify-send

RASPBERRY_USER=pi 												# your raspberry pi username
RASPBERRY_PASS=raspberry										# your raspberry pi password, the script assumes this user is in the sudoers file of the raspberry
RASPBERRY_ADDR=192.168.0.8										# IP address (or hostname if you're using a dynamic dns server)
BACKUP_FOLDER=/home/username/RB_BACKUP							# local backup destination folder
BACKUP_NAME=$(date +"%Y%m%d_%H%M")								# image filename
BACKUP_IMAGE=/home/username/RB_BACKUP/$BACKUP_NAME.img 			# absolute path to generated image

# Notify user, script is starting, useful if running this script with cron
notify-send "RASPBERRY BACKUP: Starting backup process, raspberry pi: $RASPBERRY_ADDR"

# Try to ping raspberry, if you can't find it, exit now

ping -c 3 $RASPBERRY_ADDR > /dev/null 2> /dev/null

if [ $? -ne 0 ]; then
	notify-send "RASPBERRY BACKUP: cannot ping raspberry at: $RASPBERRY_ADDR exiting"
	exit 1
fi

# If destination dir does not exist, create it
if [ ! -d "$BACKUP_FOLDER" ]; then
	mkdir $BACKUP_FOLDER
fi

notify-send "RASPBERRY BACKUP: Initiating SSH transfer, do not turn off your PC!!!"
# This opens a ssh connection with raspberry, and using dd and the unix pipe creates a local device image
sshpass -p $RASPBERRY_PASS ssh $RASPBERRY_USER@$RASPBERRY_ADDR 'echo $RASPBERRY_PASS | sudo -S dd if=/dev/mmcblk0' | dd of=$BACKUP_IMAGE
# Check if everything is ok
if [ $? -ne 0 ]; then
	notify-send "RASPBERRY BACKUP: Something went wrong with the ssh transmission, deleting temporary files, try again!"
	rm $BACKUP_IMAGE
	exit 1
fi
notify-send "RASPBERRY BACKUP: Transfer complete, compressing image..."
# Compress image
tar -pczf $BACKUP_FOLDER/$BACKUP_NAME.tar.gz $BACKUP_IMAGE
# Check compression result
if [ $? -ne 0 ]; then
	notify-send "RASPBERRY BACKUP: Backup complete, BUT it wasn't possible to compress the image"
	exit 1
fi
# Delete uncompressed files
rm $BACKUP_IMAGE
notify-send "RASPBERRY BACKUP: Backup Complete! Backup saved in $BACKUP_FOLDER"