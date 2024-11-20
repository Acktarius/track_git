#!/bin/bash
# shorcut installer for track_git_tag for Ubuntu users
# this file is subject to Licence
# Copyright (c) 2024, Acktarius
#
# make sure ./shortcut_installer.sh is an executable file
# otherwise, run: sudo chmod 755 shortcut_installer.sh
# run with command: ./shortcut_installer.sh
#
#
#variables
#user=$(id -nu 1000)
path=$(pwd)
#Functions
shortcutCreator() {
cat << EOF > $HOME/.local/share/applications/track_git_tag.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Track Git
Path=${path}
Exec=/bin/bash -c '${path}/track_git_tag.sh ; exit'
Terminal=false
Type=Application
Icon=${path}/icon/track_git.png
Hidden=false
NoDisplay=false
Terminal=false
Categories=Office
X-GNOME-Autostart-enabled=true
Comment=Track Git Repository via tag
EOF
echo "shortcut created, you may have to log out and log back in"
}
already() {
read -p  "shortcut already in place, do you want to replace it (y/N)" ans
	case $ans in
		y | Y | yes)
		rm -f $HOME/.local/share/applications/track_git_tag.desktop
		shortcutCreator
		;;
		*)
		echo "nothing done"
		;;
	esac
}
#check and install
##not already install
if [[ ! -f $HOME/.local/share/applications/track_git_tag.desktop ]]; then 
shortcutCreator
else
already
fi