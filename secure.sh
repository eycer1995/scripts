#! /bin/bash

# Make ssh connection more secure

SSH_FILE="/etc/ssh/sshd_config"

while :; do
	read -p "Enter the desired port for ssh (1024-65535): " SSH_PORT
  [[ $SSH_PORT =~ ^[0-9]+$ ]] || { echo "Enter a valid number"; continue; }
  if ((SSH_PORT >= 1024 && SSH_PORT <= 65535)); then
    echo "valid number $SSH_PORT"
    break
  else
    echo "number out of range, try again"
  fi
done

function secure()
{
	if [ -f $SSH_FILE ]; then
		echo sshd_config file found. Applying changes
		sed -i "s/#Port 22/Port $SSH_PORT/" $SSH_FILE
		sed -i 's/#HostKey/HostKey/g' $SSH_FILE
		sed -i 's/#AddressFamily any/AddressFamily inet/' $SSH_FILE
		sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' $SSH_FILE
		sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $SSH_FILE
	else
		echo sshd_config file not found
	fi

}

if [ $UID -ne 0 ]; then
echo You are not root. Please run as root.
else
	secure
fi


