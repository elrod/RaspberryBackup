RaspberryBackup
===============

Simple Remote Raspberry Server SD Backup Script.
This script connects to a remote raspberry and create a local image of it's SD card

REQUIREMENTS
---------------------

This script requires

	* ssh 
	* sshpass 
	* send-notify

you can easily find this packages in any linux major distribution repository.

SETUP
---------------------

Open the script with a text editor and set the following variables as needed

	* RASPBERRY_USER -> your raspberry pi username
	* RASPBERRY_PASS -> your raspberry pi password, the script assumes this is also the sudo password
	* RASPBERRY_ADDR -> local ip address or hostname if you are using a DNS Server
	* BACKUP_FOLDER  -> your local backup folder
	* BACKUP_NAME    -> you can leave this value as default or customize it, to do that just type "man date" on your terminal :)
	* BACKUP_IMAGE   -> the backup image full path

USAGE
---------------------

run it as you would with any other script, make it executable with:
sudo chomod +x rbBackup.sh

and run it

./rbBackup.sh

It is a good idea to schedule its execution with cron, to do that, have a look at the cron manual page:

man cron

RESTORE BACKUPS
---------------------

If you need to restore a backup, simply uncompress the backup image archive with tar. Plug in your sd card
and execute:

 * dd if=/path/to/backup.img of=/dev/devicename

then plug your sd card in your raspberry pi and turn it on