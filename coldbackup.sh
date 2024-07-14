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
seedbox_backup() {
	rsync -saP seedbox:/var/lib/transmission-daemon/downloads /mnt/ares/privseedbox

}

# Backup mam seedbox
mam_backup() {
	rsync -aP debpod01:/opt/mam/downloads/complete/ /mnt/ares/mam/downloads
}

# Backup jellyfin files and media
jellyfin_backup() {
	ROOT_JELLYFIN="/opt/hms/jellyfin"
	rsync -aP mediastage:$ROOT_JELLYFIN/animovies /mnt/ares/jellyfin
	rsync -aP mediastage:$ROOT_JELLYFIN/config /mnt/ares/jellyfin
	# movies are too heavy 238G wont fit on ares HDD
	#rsync -aP mediastage:$ROOT_JELLYFIN/movies /mnt/ares/jellyfin
	rsync -aP mediastage:$ROOT_JELLYFIN/tvseries /mnt/ares/jellyfin
	# kdrama gets too heavy and repeated from seedbox backup
	#rsync -aP mediastage:$ROOT_JELLYFIN/kdrama /mnt/ares/jellyfin

    ssh mediastage "ls /opt/hms/jellyfin/anime" > /mnt/ares/anime.txt
    ssh mediastage "ls /opt/hms/jellyfin/animovies" > /mnt/ares/animovies.txt
    ssh mediastage "ls /opt/hms/jellyfin/movies" > /mnt/ares/movies.txt
}

hms_config_backup() {
	ROOT_HMS="/opt/hms"
	#bazarr  jackett jellyseerr  radarr  sonarr  tvsonarr
	sudo rsync -aP -e "ssh -F /home/eycer/.ssh/config" --rsync-path="sudo rsync" mediastage:$ROOT_HMS/bazarr /mnt/ares
	sudo rsync -aP -e "ssh -F /home/eycer/.ssh/config" --rsync-path="sudo rsync" mediastage:$ROOT_HMS/jackettt /mnt/ares
	sudo rsync -aP -e "ssh -F /home/eycer/.ssh/config" --rsync-path="sudo rsync" mediastage:$ROOT_HMS/jellyseerr /mnt/ares
	sudo rsync -aP -e "ssh -F /home/eycer/.ssh/config" --rsync-path="sudo rsync" mediastage:$ROOT_HMS/radarr /mnt/ares
	sudo rsync -aP -e "ssh -F /home/eycer/.ssh/config" --rsync-path="sudo rsync" mediastage:$ROOT_HMS/sonarr /mnt/ares
	sudo rsync -aP -e "ssh -F /home/eycer/.ssh/config" --rsync-path="sudo rsync" mediastage:$ROOT_HMS/tvsonarr /mnt/ares
}

kavita_backup() {
	rsync -aP kavita:/opt/kavita/manga /mnt/eros
	rsync -aP kavita:/opt/kavita/config/backups  /mnt/eros
}

# Check if cold HDD is present
if sudo blkid -s UUID -o value /dev/sdd1 | grep -q "$ARES_UUID"; then
  # Check if /mnt/ares is already mounted, if not mount it.
  df -h /mnt/ares
  sudo mount -U $ARES_UUID /mnt/ares
  if [ $? -eq 0 ]; then
	  echo "HDD ares is already mounted"
  else
	  echo "mounting ares"
	  sudo mount -U $ARES_UUID /mnt/ares
	  echo "Hard drive with UUID $ARES_UUID mounted on /mnt/ares"
  fi
  home_backup
  gitea_backup
  seedbox_backup
  mam_backup
  jellyfin_backup
  hms_config_backup

elif sudo blkid -s UUID -o value /dev/sde1 | grep -q "$EROS_UUID"; then
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
