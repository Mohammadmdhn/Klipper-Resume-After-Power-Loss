#!/bin/bash

USER_HOME=$(eval echo ~$USER)

echo "Removing Royal3DP-Klipper-PLR files and configurations..."

# حذف plr.cfg از مسیر config
rm -f $USER_HOME/printer_data/config/plr.cfg && echo "plr.cfg removed."

# حذف gcode_shell_command.py از Klipper
rm -f $USER_HOME/klipper/klippy/extras/gcode_shell_command.py && echo "gcode_shell_command.py removed."

# حذف سطر include از printer.cfg
sed -i '/\[include plr.cfg\]/d' $USER_HOME/printer_data/config/printer.cfg && echo "plr.cfg include removed from printer.cfg."

# حذف سطر include از moonraker.conf
sed -i '/\[include update_royal3d_plr.cfg\]/d' $USER_HOME/printer_data/config/moonraker.conf && echo "update_royal3d_plr.cfg include removed from moonraker.conf."

# حذف update_royal3d_plr.cfg
rm -f $USER_HOME/printer_data/config/update_royal3d_plr.cfg && echo "update_royal3d_plr.cfg removed."

# حذف دایرکتوری plr
rm -rf $USER_HOME/printer_data/gcodes/plr && echo "plr directory removed."

echo "Royal3DP-Klipper-PLR uninstallation completed."
