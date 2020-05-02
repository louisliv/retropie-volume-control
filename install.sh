#!/bin/bash

GREEN='\033[0;32m'
LGREEN='\033[1;32m'
LRED='\033[1;31m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
NC='\033[0m'
RUNASROOT="run-as-root"
NOROOT="no-root"

clear
echo -e " ${LRED}########################################${NC}"
echo -e " ${LRED}#${NC}  ${GREEN}Installing RetroPie Volume Control${NC}  ${LRED}#${NC}"
echo -e " ${LRED}########################################${NC}\n"

RVCGITBRANCH="master"
RVC="$HOME/retropie-volume-control"
RP="$HOME/RetroPie"
RPMENU="$RP/retropiemenu"
THCONFIGS="/etc/triggerhappy/triggers.d"

########################
##  Remove Old Files  ##
########################
echo -e " ${LRED}-${NC}${WHITE} Removing old files...${NC}"
rm -rf $RVC
sudo rm "$THCONFIGS/sound.conf"
rm "$RPMENU/sound-config.sh"

#############################
##Packages and Dependencies##
#############################
echo -e "\n ${LRED}[${NC} ${LGREEN}Packages and Dependencies Installation${NC} ${LRED}]${NC}"
sleep 1

echo -e " ${LRED}-${NC}${WHITE} Checking packages and dependencies...${NC}"
sleep 1

packages=("dialog" "python3-dev" "python-dev" "python3-pip" "python-pip" "libasound2-dev" "python3-dialog" "unzip")

for package in "${packages[@]}"; do
	if dpkg -s $package >/dev/null 2>&1; then
		echo -e " ${LRED}--${NC}${WHITE} $package : ${NC}${LGREEN}Installed${NC}"
	else
		echo -e " ${LRED}--${NC}${WHITE} $package : ${NC}${LRED}Not Installed${NC}"
		installpackages+=("$package")
	fi
done

if [ ${#installpackages[@]} -gt 0 ]; then
	
	echo -e " ${LRED}---${NC}${WHITE} Installing missing packages and dependencies...${NC}${ORANGE}\n"
	sleep 1
	
	sudo apt-get update; sudo apt-get install -y ${installpackages[@]}

fi

python3 -m pip install pyalsaaudio==0.8.4

echo -e "\n ${NC}${LRED}--${NC}${GREEN} All packages and dependencies are installed.${NC}\n"

sleep 1

########################
########################

############################
## Install Volume Control ##
############################

echo -e " ${LRED}[${NC}${LGREEN} Installing RetroPie Volume Control ${NC}${LRED}]${NC}"
sleep 1

echo -e " ${LRED}-${NC}${WHITE} Creating folders...${NC}"
sleep 1
mkdir -p -m 0777 $RVC

echo -e " ${LRED}--${NC}${WHITE} Downloading system files...${NC}${ORANGE}\n"
sleep 1

cd $RVC
wget -N -q https://github.com/louisliv/retropie-volume-control/files/4567234/retropie-volume-control.zip
unzip retropie-volume-control.zip
rm retropie-volume-control.zip

echo -e " ${LRED}--${NC}${WHITE} Writing system files...${NC}${ORANGE}\n"
sleep 1

cd $RPMENU
sudo cp $RVC/sound-config.sh .

cd $THCONFIGS
RVCFILES=("sound.conf")
sudo cp $RVC/sound.conf .
sleep 1

########################
########################

##########################
## Permissions ##
##########################
echo -e "\n ${LRED}-${NC}${WHITE} Setting permissions...${NC}\n"
cd $RPMENU
chmod +x sound-config.sh
cd $RVC
chmod +x sound-config.sh
sleep 1

########################
########################

##########################
## Restart Triggerhappy ##
##########################
echo -e "\n ${LRED}-${NC}${WHITE} Restarting triggerhappy...${NC}\n"
sudo systemctl restart triggerhappy
sleep 1

########################
########################

###############
## Complete! ##
###############
echo -e "\n ${LRED}-${NC}${WHITE} Installation Complete!...${NC}\n"
sleep 1
