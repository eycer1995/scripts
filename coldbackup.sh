#!/bin/bash

ARES_UUID="a966cba4-576b-4a35-9ef2-13036b62aea5"
EROS_UUID="0a3043f4-638b-4a13-8872-1f7563fb7a0c"
ROOT_HOME_BACKUP="/mnt/odin/backup/personal"

home_backup() {
# /home/eycer from hot backup
	rsync -aP $ROOT_HOME_BACKUP /mnt/ares
}
# Backup gitea
gitea_backup() {
	rsync -aP debpod01:/opt/gitea/backup/ /mnt/ares/gitea
}

# Backup privseedbox
privseedbox_backup() {
	rsync -saP privseedbox:/var/lib/transmission-daemon/downloads /mnt/ares/privseedbox

}

# Backup mam seedbox
mam_backup() {
	rsync -aP debpod01:/opt/mam/downloads/complete/ /mnt/ares/mam/downloads
}

# Backup jellyfin files and media
jellyfin_backup() {
	ROOT_JELLYFIN="/mnt/hades/hms/jellyfin"
	rsync -aP rpi01:$ROOT_JELLYFIN/animovies /mnt/ares/jellyfin
	rsync -aP rpi01:$ROOT_JELLYFIN/config /mnt/ares/jellyfin
	rsync -aP rpi01:$ROOT_JELLYFIN/movies /mnt/ares/jellyfin
	rsync -aP rpi01:$ROOT_JELLYFIN/tvseries /mnt/ares/jellyfin
	rsync -aP rpi01:$ROOT_JELLYFIN/kdrama /mnt/ares/jellyfin
}

kavita_backup() {
	rsync -aP kavita:/opt/kavita/manga /mnt/eros
	rsync -aP kavita:/opt/kavita/config/backups  /mnt/eros
}

# Check if cold HDD is present
if sudo blkid -s UUID -o value /dev/sdd1 | grep -q "$ARES_UUID"; then
  # Check if /mnt/ares is already mounted, if not mount it.
  df -h /mnt/ares
  if [ $? -eq 0 ]; then
	  echo "HDD ares is already mounted"
  else
	  echo "mounting ares"
	  sudo mount -U $ARES_UUID /mnt/ares
	  echo "Hard drive with UUID $ARES_UUID mounted on /mnt/ares"
  fi
  home_backup
  gitea_backup
  privseedbox_backup
  mam_backup
  jellyfin_backup

elif sudo blkid -s UUID -o value /dev/sdd1 | grep -q "$EROS_UUID"; then
  # Check if /mnt/eros is already mounted, if not mount it.
  df -h /mnt/eros
  if [ $? -eq 0 ]; then
	  echo "HDD eros is already mounted"
  else
	  echo "mounting eros"
	  sudo mount -U $EROS_UUID /mnt/eros
	  echo "Hard drive with UUID $EROS_UUID mounted on /mnt/eros"
  fi
  kavita_backup

else
  echo "There are no cold HDDs present"
fi
