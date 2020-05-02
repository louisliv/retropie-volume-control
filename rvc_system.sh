#!/bin/bash

# Avoid multiple starts, so force close
[[ "$(pgrep -c -f $(basename $0))" -gt 1 ]] && exit

function execute() {
	if [ "$#" -gt 0 ]; then

		case "$1" in
			-i)
				(bgm_init "$2" &)
				;;
            *)
                exit
                ;;
        esac
    else
        exit
    fi
}

function rvc_init(){

    # if script called from autostart.sh, wait for omxplayer (splashscreen) to end
    if [ "$1" == "--autostart" ]; then
        while pgrep omxplayer >/dev/null; do sleep 1; done
        sudo restart
        sleep 1
    fi
}

execute "$@"