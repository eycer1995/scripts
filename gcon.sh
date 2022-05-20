#! /bin/bash

# Check git connection, if denied retablish the connection
ssh git@github.com 2>/tmp/gcon.txt
con_status=$(cat /tmp/gcon.txt | awk '{print $3}')

if [ $con_status == "denied" ]; then
	echo Connection denied... reestablishing
	ssh-add ~/.ssh/github
	echo Done.
else
	echo Connection is ok.
fi
