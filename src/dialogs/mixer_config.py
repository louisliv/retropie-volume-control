import json
import os

from controls.set_config import set_mixer
from dialogs.constants import MIXER_CHOICES

def mixer_conf(dialog):
    this_folder = os.path.dirname(os.path.abspath(__file__))
    config_json_path = os.path.join(this_folder, '..', 'config.json')
    config_file = open(config_json_path)
    config = json.load(config_file)
    config_file.close()

    code, tag = dialog.menu(
        "Main Menu",
        choices=MIXER_CHOICES)

    if code == dialog.OK:
        set_mixer(config_json_path, config, tag)