#!/bin/bash 

clear
echo -e "#######################################"
echo -e "#  Uninstall RetroPie Volume Control  #"
echo -e "#######################################\n"

RVC="$HOME/retropie-volume-control"
RP="$HOME/RetroPie"
RPMENU="$RP/retropiemenu"
RPCONFIGS="/opt/retropie/configs/all"
THCONFIGS="/etc/triggerhappy/triggers.d"

SCRIPTPATH=$(realpath $0)

##################
## Remove files ##
##################
echo -e " ${LRED}-${NC}${WHITE} Removing files...${NC}"
sudo rm "$THCONFIGS/sound.conf"
rm -rf $RVC
rm "$RPMENU/retropie_volume_config.sh"
sed -i "/rvc_system.sh/d" $RPCONFIGS/runcommand-onstart.sh >/dev/null 2>&1
sed -i "/rvc_system.sh/d" $RPCONFIGS/autostart.sh >/dev/null 2>&1

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

########################
##       Restart      ##
########################
echo -e "[Restart System]"
echo -e "\n-To finish, we need to reboot.\n"
read -n 1 -s -r -p "Press any key to Restart."
echo -e "\n"
(rm -f $SCRIPTPATH; sudo reboot)
########################
########################