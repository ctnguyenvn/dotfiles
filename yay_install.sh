#!/bin/sh

mkdir sources &&
	cd sources &&
	git clone https://aur.archlinux.org/yay.git &&
	cd yay &&
	makepkg -si &&
	yay -editmenu -nodiffmenu -save
