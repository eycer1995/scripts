#!/bin/bash


SSH_DIR="/home/eycer/.ssh"

read -p "What is the server IP? " SERVER_IP
read -p "Type the key name: " KEYNAME

ssh-keygen -t rsa -b 4096 -f "$SSH_DIR"/"$KEYNAME" -q -N ""

echo "Please insert the password used for ssh login on remote machine:"
read -r USERPASS

echo "$USERPASS" | sshpass ssh-copy-id -i "$SSH_DIR"/"$KEYNAME" eycer@"$SERVER_IP"
