#!/bin/bash

# Declaring root folders for source and destination
#
ROOT_LOCAL="/home/eycer"
ROOT_BACKUP="/mnt/odin/backup/personal"

# Do a test before running the actual backup

echo "Doing dry run"
echo
echo "Documents folder:"
rsync -a --dry-run --stats --delete "$ROOT_LOCAL/Documents/" "$ROOT_BACKUP/Documents/"
echo
echo "Downloads folder:"
rsync -a --dry-run --stats --delete "$ROOT_LOCAL/Downloads/" "$ROOT_BACKUP/Downloads/"
echo
echo "Pictures folder:"
rsync -a --dry-run --stats --delete "$ROOT_LOCAL/Pictures/" "$ROOT_BACKUP/Pictures/"
echo
echo "Music folder:"
rsync -a --dry-run --stats --delete "$ROOT_LOCAL/Music/" "$ROOT_BACKUP/Music/"
echo
echo "Factorio folder:"
rsync -a --dry-run --stats --delete "$ROOT_LOCAL/.factorio" "$ROOT_BACKUP"
echo
echo "SSH folder:"
rsync -a --dry-run --stats --delete "$ROOT_LOCAL/.ssh" "$ROOT_BACKUP"

while true; do
    read -p "Do you want to proceed with the backup? " APPROVAL
    case $APPROVAL in
        [Yy]* )
			rsync -aP --delete "$ROOT_LOCAL/Documents/" "$ROOT_BACKUP/Documents/"
			rsync -aP --delete "$ROOT_LOCAL/Downloads/" "$ROOT_BACKUP/Downloads/"
			rsync -aP --delete "$ROOT_LOCAL/Pictures/" "$ROOT_BACKUP/Pictures/"
			rsync -aP --delete "$ROOT_LOCAL/Music/" "$ROOT_BACKUP/Music/"
			rsync -aP --delete "$ROOT_LOCAL/.factorio" "$ROOT_BACKUP"
			rsync -aP --delete "$ROOT_LOCAL/.ssh" "$ROOT_BACKUP"
			break
			;;
        [Nn]* ) 
			echo "Aborting operation..."
			exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

