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
##remove older version##
########################
echo -e " ${LRED}-${NC}${WHITE} Removing older versions...${NC}"
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

packages=("dialog" "python3-dev" "python-dev" "libasound2-dev" "python3-dialog" "unzip")

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
	PATH=${files[last_id]}
	unset files[last_id]

	for i in "${files[@]}"; do
		echo "https://raw.githubusercontent.com/louisliv/retropie-volume-control/$RVCGITBRANCH/$i"

		case $PATH in

			"run-as-root")
				/usr/bin/sudo /usr/bin/wget -N -q --show-progress "https://raw.githubusercontent.com/louisliv/retropie-volume-control/$RVCGITBRANCH/$i"
				;;

			"no-root")
				/usr/bin/wget -N -q --show-progress "https://raw.githubusercontent.com/louisliv/retropie-volume-control/$RVCGITBRANCH/$i"
				;;
		esac
	done
}

cd $RVC
RVCFILES=("config.json" "src.zip" "volctrl.py" "set_config.py")
gitdownloader ${RVCFILES[@]} $NOROOT
unzip src.zip

cd $RPMENU
BGMFILES=("sound-config.sh")
gitdownloader ${BGMFILES[@]} $NOROOT

cd $THCONFIGS
RVCFILES=("sound.conf")
gitdownloader ${RVCFILES[@]} $RUNASROOT
sleep 1

########################
########################

##########################
## Permissions ##
##########################
echo -e "\n ${LRED}-${NC}${WHITE} Setting permissions...${NC}\n"
cd $RPMENU
chmod +x sound-config.sh
sleep 1

########################
########################

##########################
## Restart Triggerhappy ##
##########################
echo -e "\n ${LRED}-${NC}${WHITE} Restarting triggerhappy...${NC}\n"
/usr/bin/sudo systemctl restart triggerhappy
sleep 1

########################
########################

###############
## Complete! ##
###############
echo -e "\n ${LRED}-${NC}${WHITE} Installation Complete!...${NC}\n"
sleep 1