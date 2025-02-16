#!/bin/bash

REAL_USER="$USER"
OWNER=""

if [ -n "$SUDO_USER" ]; then
    echo "Shell script executed with sudo, user is $SUDO_USER"
    if [ "$SUDO_USER" = "runner" ]; then
        USER_HOME="/home/mks"
        OWNER="mks"
    else
        USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
        OWNER="$SUDO_USER"
    fi
else
    USER_HOME=$(getent passwd "$USER" | cut -d: -f6)
    OWNER="$USER"
    echo "Shell script executed without sudo, user is $USER"
fi

echo "Real user: $REAL_USER"
echo "User's home directory: $USER_HOME"
echo "Owner for chown: $OWNER"

KLIPPER_DIR="$USER_HOME/klipper"

PLR_CFG_URL="https://raw.githubusercontent.com/Mohammadmdhn/Royal3DP-Klipper-PLR/main/plr.cfg"
GCODE_SHELL_CMD_URL="https://raw.githubusercontent.com/Mohammadmdhn/Royal3DP-Klipper-PLR/main/gcode_shell_command.py"

TMP_DIR=$(mktemp -d)

curl -fsSL "$PLR_CFG_URL" -o "$TMP_DIR/plr.cfg"
curl -fsSL "$GCODE_SHELL_CMD_URL" -o "$TMP_DIR/gcode_shell_command.py"

cp -f $TMP_DIR/plr.cfg $USER_HOME/printer_data/config/ && echo "plr.cfg copied successfully." || echo "Error copying plr.cfg."
cp -f $TMP_DIR/gcode_shell_command.py $KLIPPER_DIR/klippy/extras/ && echo "gcode_shell_command.py copied successfully." || echo "Error copying gcode_shell_command.py."

if grep -Fxq '[include plr.cfg]' $USER_HOME/printer_data/config/printer.cfg; then
    echo "[include plr.cfg] is already present in printer.cfg."
else
    temp_file=$(mktemp)
    echo "[include plr.cfg]" > "$temp_file"
    cat $USER_HOME/printer_data/config/printer.cfg >> "$temp_file"
    mv "$temp_file" $USER_HOME/printer_data/config/printer.cfg
    echo "[include plr.cfg] added to printer.cfg."
fi

if grep -Fxq '[include update_royal3d_plr.cfg]' $USER_HOME/printer_data/config/moonraker.conf; then
    echo "[include update_royal3d_plr.cfg] is already present in moonraker.conf."
else
    temp_file=$(mktemp)
    echo "[include update_royal3d_plr.cfg]" > "$temp_file"
    cat $USER_HOME/printer_data/config/moonraker.conf >> "$temp_file"
    mv "$temp_file" $USER_HOME/printer_data/config/moonraker.conf
    echo "[include update_royal3d_plr.cfg] added to moonraker.conf."
fi

if [ -f $USER_HOME/printer_data/config/update_royal3d_plr.cfg ]; then
    rm $USER_HOME/printer_data/config/update_royal3d_plr.cfg
    echo "update_royal3d_plr.cfg already exists, deleting..."
fi

cat > $USER_HOME/printer_data/config/update_royal3d_plr.cfg << EOF
[update_manager royal3d_plr]
type: git_repo
path: ~/Royal3DP-Klipper-PLR
origin: https://github.com/Mohammadmdhn/Royal3DP-Klipper-PLR.git
primary_branch: main
install_script: install.sh
is_system_service: False
EOF

echo "Royal3D-PLR installation complete."
