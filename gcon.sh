#! /bin/bash

# Check git connection, if denied retablish the connection
ssh git@github.com 2>/tmp/gcon.txt
con_status=$(cat /tmp/gcon.txt | awk '{print $3}')

SSH_AGENT_PID=$(ps -fea | grep "ssh-agent" | grep -v grep | head -1 | awk '{print $2}')

if [ $con_status == "denied" ]; then
    echo "Connection denied... reestablishing"
    	
    	# Verify if ssh-agent is running, if not start it.
        if [[ $SSH_AGENT_PID -gt 1 ]]; then	
	    echo "ssh-agent running PID [$SSH_AGENT_PID]"
	else
	    echo "ssh-agent not running"
	    eval `ssh-agent -s`
	fi
	
	# Add the key to the agent
	if  [[ -e ~/.ssh/github ]]; then
	    ssh-add ~/.ssh/github
	fi
	echo Done.
else
	echo Connection is ok.
fi
