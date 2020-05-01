#!/bin/bash 

clear
echo -e "#######################################"
echo -e "#  Uninstall RetroPie Volume Control  #"
echo -e "#######################################\n"

RVC="$HOME/retropie-volume-control"
THCONFIGS="/etc/triggerhappy/triggers.d"

##################
## Remove files ##
##################
echo -e " ${LRED}-${NC}${WHITE} Removing files...${NC}"
rm -rf $RVC
rm "$THCONFIGS/sound.conf"

##########################
## Restart Triggerhappy ##
##########################
echo -e "\n ${LRED}-${NC}${WHITE} Restarting triggerhappy...${NC}\n"
sudo systemctl restart triggerhappy
sleep 1

###############
## Complete! ##
###############
echo -e "\n ${LRED}-${NC}${WHITE} Retropie Volume Control has been removed!...${NC}\n"
sleep 1