#! /bin/bash
sudo udevadm control --reload-rules
systemctl --user restart opentabletdriver
echo "Done"
