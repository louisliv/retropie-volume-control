#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

# trap and delete temp files
trap "rm $INPUT; rm $OUTPUT; exit" SIGHUP SIGINT SIGTERM

function display_increment(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	dialog --backtitle "Retropie Sound Ctrl Config" --title "Set Increment" \
	--clear \
	--inputbox "Increment" ${h} ${w} 2>"${OUTPUT}"
	$DIR/base/bin/python $DIR/main.py increment=$(<$OUTPUT)
}

function show_increment(){
    display_increment 6 60
}

function display_mixer(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local z=${3-40}
	dialog --backtitle "Retropie Sound Ctrl Config" --title "Set Mixer" \
	--clear \
	--menu "Mixer" ${h} ${w} ${z} \
	Master "Master" \
	PCM "PCM" \
	Line_Out "Line Out" \
	Headphone "Headphone" 2>"${OUTPUT}"
	$DIR/base/bin/python $DIR/main.py mixer=$(<$OUTPUT)
}

function show_mixer(){
    display_mixer 16 51 45
}

while true
do

# Generate the dialog box
dialog --title "Retropie Sound Ctrl Config" \
--clear  \
--menu "Select" 16 51 45 \
Increment "Set Volume Increment" \
Mixer "Set Mixer" \
Exit "Exit to the shell" 2>"${INPUT}" 

# Get the exit status
menu_item=$(<"${INPUT}")

if test -z "$menu_item"
then
	break
fi

# Act on it
case $menu_item in
  Increment) show_increment;;
  Mixer) show_mixer;;
  Exit) break;;
esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT