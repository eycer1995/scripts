#!/bin/bash
# Restore from backup.sh

ROOT_LOCAL="/home/eycer"
ROOT_BACKUP="/mnt/odin/backup/personal"


rsync -aP --delete "$ROOT_BACKUP/Documents/" "$ROOT_LOCAL/Documents/"
rsync -aP --delete "$ROOT_BACKUP/Downloads/" "$ROOT_LOCAL/Downloads/"
rsync -aP --delete "$ROOT_BACKUP/Pictures/" "$ROOT_LOCAL/Pictures/"
rsync -aP --delete "$ROOT_BACKUP/Music/" "$ROOT_LOCAL/Music/"
rsync -aP --delete "$ROOT_BACKUP/.factorio" "$ROOT_LOCAL"
rsync -aP --delete "$ROOT_BACKUP/.ssh" "$ROOT_LOCAL"

