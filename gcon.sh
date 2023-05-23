#! /bin/bash

# Check git connection, if denied retablish the connection
ssh git@github.com 2>/tmp/gcon.txt
con_status=$(cat /tmp/gcon.txt | awk '{print $3}')

if [ $con_status == "denied" ]; then
    echo "Connection denied... reestablishing"
    	
	# Add the key to the agent
	if  [[ -e ~/.ssh/github ]]; then
	    ssh-add ~/.ssh/github
		echo "Key added."
	fi
else
	echo Connection is ok.
fi
