#!/usr/bin/python

import os
import json
import sys
from controls.volctrl import set_volume
from controls.set_config import set_config
from dialogs.start import start_config

def main(**kwargs):
    this_folder = os.path.dirname(os.path.abspath(__file__))
    config_json_path = os.path.join(this_folder, 'config.json')

    direction = kwargs.get('direction', None)

    if direction:
        config_file = open(config_json_path)
        config = json.load(config_file)
        config_file.close()

        increment = config['increment']
        mixer = config['mixer']
        set_volume(mixer, increment, direction)
    else:
        increment = kwargs.get('increment', None)
        mixer = kwargs.get('mixer', None)
        set_config(config_json_path, increment=increment, mixer=mixer)

def process_args(args):
    kwargs = {}

    for arg in args:
        kwargs[arg.split("=")[0]] = arg.split("=")[1]

    return kwargs

if __name__ == "__main__":
    kwargs = process_args(sys.argv[1:])
    if kwargs.get('dialog', None):
        start_config()
    else:
        main(**kwargs)
