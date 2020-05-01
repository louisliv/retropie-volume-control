#!/bin/bash

GREEN='\033[0;32m'
LGREEN='\033[1;32m'
RED='\033[0;31m'
LRED='\033[1;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
NC='\033[0m'

clear
echo -e " ${LRED}####################################${NC}"
echo -e " ${LRED}#${NC}  ${GREEN}Installing RetroPie_Volume_Control${NC}  ${LRED}#${NC}"
echo -e " ${LRED}####################################${NC}\n"

RVCGITBRANCH="master"
RVC="$HOME/retropie-volume-control"
RP="$HOME/RetroPie"
RPMENU="$RP/retropiemenu"
RPSETUP="$HOME/RetroPie-Setup"
THCONFIGS="/etc/triggerhappy/triggers.d"

SCRIPTPATH=$(realpath $0)

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

########################
##remove older version##
########################
echo -e " ${LRED}-${NC}${WHITE} Removing older versions...${NC}"
rm -rf $RVC
rm "$THCONFIGS/sound.conf"

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
		wget -N -q --show-progress "https://raw.githubusercontent.com/louisliv/retropie-volume-control/$RVCGITBRANCH/$i"
		#chmod a+rwx "$i"
	done
}

cd $RVC
RVCFILES=("sound-config.sh" "config.json" "main.py" "__init__.py" "volctrl.py" "set_config.py")
gitdownloader ${RVCFILES[@]} "/retropie-volume-control"

cd $THCONFIGS
RVCFILES=("sound.conf")
gitdownloader ${RVCFILES[@]} "/retropie-volume-control"

echo -e " ${LRED}-${NC}${WHITE} Restarting triggerhappy...${NC}"
sudo systemctl restart triggerhappy
sleep 1