# RetroPie Volume Control
A simple volume control driver for keyboard volume control media buttons in RetroPie. Bash scripts were drawn heavily from Naprosnia's [Retropie_BGM_Player](https://github.com/Naprosnia/RetroPie_BGM_Player) project. Retropie Volume Control uses alsamixer and triggerhappy to raise and lower a set mixer's volume by a specified percentage or mute the mixer by using the Volume Up, Volume Down, or Mute keys. Both the mixer and the specified percentage can be set using the `sound-config.sh` script. 

## Installation
1. `wget -N https://raw.githubusercontent.com/louisliv/retropie-volume-control/master/install.sh`
2. `chmod +x install.sh`
3. `./install.sh`

## Config
To start the config script, follow these steps:
1. `cd ~/retropie-volume-control`
2. `./sound-config.sh`

## Uninstall
1. `wget -N https://raw.githubusercontent.com/louisliv/retropie-volume-control/master/uninstall.sh`
2. `chmod +x uninstall.sh`
3. `./uninstall.sh`

## Known Issues
* Currently volume control will not work while in Emulationstation, only while in an emulator.

## Planned Additions
* Add Retropie Volume Control config script to Retropie menu in Emulationstation
* Fix Emulationstation volume control issue. 

Test
