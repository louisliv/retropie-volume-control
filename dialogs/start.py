from dialog import Dialog

from dialogs.constants import MAIN_MENU_CHOICES
from dialogs.increment_conf import increment_conf
from dialogs.mixer_config import mixer_conf

def start_config():
    d = Dialog(dialog="dialog")
    d.set_background_title("Retropie Volume Control")

    show_main_menu(d)

def show_main_menu(d):
    code, tag = d.menu(
        "Main Menu",
        choices=MAIN_MENU_CHOICES)
    if code == d.OK:
        if tag in ["(1)"]:
            increment_conf(d)
        elif tag in ["(2)"]:
            mixer_conf(d)

        show_main_menu(d)