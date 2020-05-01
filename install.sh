#!/bin/bash

GREEN='\033[0;32m'
LGREEN='\033[1;32m'
LRED='\033[1;31m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
NC='\033[0m'

clear
echo -e " ${LRED}########################################${NC}"
echo -e " ${LRED}#${NC}  ${GREEN}Installing RetroPie Volume Control${NC}  ${LRED}#${NC}"
echo -e " ${LRED}########################################${NC}\n"

RVCGITBRANCH="master"
RVC="$HOME/retropie-volume-control"
THCONFIGS="/etc/triggerhappy/triggers.d"

########################
##remove older version##
########################
echo -e " ${LRED}-${NC}${WHITE} Removing older versions...${NC}"
rm -rf $RVC
sudo rm "$THCONFIGS/sound.conf"

#############################
##Packages and Dependencies##
#############################
echo -e "\n ${LRED}[${NC} ${LGREEN}Packages and Dependencies Installation${NC} ${LRED}]${NC}"
sleep 1

echo -e " ${LRED}-${NC}${WHITE} Checking packages and dependencies...${NC}"
sleep 1

packages=("dialog" "python3-dev" "python-dev" "libasound2-dev")

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

python -m pip install pyalsaaudio==0.8.4

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

function gitdownloader(){

	files=("$@")
	((last_id=${#files[@]} - 1))
	path=${files[last_id]}
	unset files[last_id]

	for i in "${files[@]}"; do
		echo "https://raw.githubusercontent.com/louisliv/retropie-volume-control/$RVCGITBRANCH/$i"
		if $path == "run-as-root"
		sudo wget -N -q --show-progress "https://raw.githubusercontent.com/louisliv/retropie-volume-control/$RVCGITBRANCH/$i"
		#chmod a+rwx "$i"
		else
		wget -N -q --show-progress "https://raw.githubusercontent.com/louisliv/retropie-volume-control/$RVCGITBRANCH/$i"
	done
}

cd $RVC
RVCFILES=("sound-config.sh" "config.json" "main.py" "__init__.py" "volctrl.py" "set_config.py" "uninstall.sh")
gitdownloader ${RVCFILES[@]} "no-root"

cd $THCONFIGS
RVCFILES=("sound.conf")
gitdownloader ${RVCFILES[@]} "run-as-root"
sleep 1
########################
########################

##########################
## Restart Triggerhappy ##
##########################
echo -e "\n ${LRED}-${NC}${WHITE} Restarting triggerhappy...${NC}\n"
sudo systemctl restart triggerhappy
sleep 1

###############
## Complete! ##
###############
echo -e "\n ${LRED}-${NC}${WHITE} Installation Complete!...${NC}\n"
sleep 1