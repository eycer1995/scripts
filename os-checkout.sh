#! /bin/bash

echo "--- Uptime ---"
echo
uptime
echo
echo "--- End Uptime ---"
echo
echo "--- OS Information ---"
echo
uname -a
echo
echo -e "\e[1;36mCurrent Kernel\e[0m: `uname -r`"
echo
echo -e "\e[1;36mCurrent NVIDIA Driver\e[0m: `modinfo -F version nvidia`"
echo
# Next kernel to boot:
# sudo grubby --info=ALL | grep kernel | head -n 1 | awk -F"-" '{print $2,$3}' | sed 's/.$//'
echo
cat /etc/os-release | head -n 4
echo
echo "--- End OS Information ---"
echo
echo "--- Disk Information ---"
echo
df -h
echo
echo "---End Disk Information ---"
echo
echo "--- Network Information ---"
echo
ip a
echo
echo "--- End Network Information ---"

