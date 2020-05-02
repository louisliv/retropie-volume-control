import json
import os

from controls.set_config import set_increment

def increment_conf(dialog):
    this_folder = os.path.dirname(os.path.abspath(__file__))
    config_json_path = os.path.join(this_folder, '..', 'config.json')
    config_file = open(config_json_path)
    config = json.load(config_file)
    config_file.close()

    code, tag = dialog.rangebox(
        "Select a new increment", 
        height=10, 
        width=50, 
        min=1, 
        max=99,
        init=config['increment']
    )

    if code == dialog.OK:
        set_increment(config_json_path, config, tag)