#!/usr/bin/env bash

# check release
if [ ! -f /etc/arch-release ]; then
	exit 0
fi

# check for updates
aur=$(yay -Qua | wc -l)
ofc=$(pacman -Qu | wc -l)

# calculate total available updates
upd=$((ofc + aur))
echo "$upd"

# show tooltip
if [ $upd -eq 0 ]; then
	echo " Packages are up to date"
else
	notify-send -a "System Updates" -i "software-update-urgent" "📦 System Updates" "Official repositories: $ofc packages\\nAUR packages: $aur packages\\n"
fi
