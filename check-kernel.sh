#! /bin/bash
# Check new kernel version upgrade.

NEW_KERNEL=$(dnf check-update -y | grep ^kernel.x86 | awk '{print $2}')

CURRENT_KERNEL=$(uname -r | awk -F"." '{print $1"."$2"."$3"."$4}')

echo "$CURRENT_KERNEL ==> $NEW_KERNEL"
