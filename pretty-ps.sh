#! /bin/bash
# Simple pretty ps for podman

red_color="\e[1;31m"
green_color="\e[1;32m"
end_color="\e[0m"

total=$(podman ps -a --format "{{.ID}}" | wc -l)
echo "Total containers: $total"

running=$(podman ps --format "{{.ID}}" | wc -l)
echo "Containers running: $running"; echo


echo "Containers status:"
podman ps -a --format "{{.Names}} {{.Status}}" > ~/ps.txt

cat ~/ps.txt | while read line; do
state=$( echo $line | awk '{print $2}' )
name=$( echo $line | awk '{print $1}' )
if [[ $state == "Exited" ]]; then
	echo -e "$name: $red_color Down $end_color"
else
	echo -e "$name: $green_color Up $end_color"
fi
done
