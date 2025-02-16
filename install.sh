#!/bin/bash
#mohamad_madahiana-royal3dp.ir_09137817673
#https://royal3dp.ir/
#https://www.linkedin.com/in/mohammad-madahian-5ab2b622a/
#https://github.com/Mohammadmdhn
REAL_USER="$USER"
OWNER=""

if [ -n "$SUDO_USER" ]; then
    echo "Shell script executed with sudo, user is $SUDO_USER"
    if [ "$SUDO_USER" = "runner" ]; then
        USER_HOME="/home/pi"
        OWNER="pi"
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
PROJECT_DIR="$PWD"

if [ "$1" == "remove" ]; then
  echo "Remove option is not yet implemented."
else
  if [ ! -f $USER_HOME/printer_data/config/variables.cfg ]; then
    touch $USER_HOME/printer_data/config/variables.cfg && echo "variables.cfg created successfully." || echo "Error creating variables.cfg."
  fi

  cp -f $PROJECT_DIR/plr.cfg $USER_HOME/printer_data/config/ && echo "plr.cfg copied successfully." || echo "Error copying plr.cfg."
  cp -f $PROJECT_DIR/gcode_shell_command.py $KLIPPER_DIR/klippy/extras/ && echo "gcode_shell_command.py copied successfully." || echo "Error copying gcode_shell_command.py."

  if [ ! -f $USER_HOME/printer_data/config/printer.cfg ]; then
      touch $USER_HOME/printer_data/config/printer.cfg && echo "printer.cfg created successfully." || echo "Error creating printer.cfg."
  fi

  if [ ! -f $USER_HOME/printer_data/config/printer.cfg ]; then
    echo "Error: $USER_HOME/printer_data/config/printer.cfg does not exist."
  fi

  if grep -Fxq '[include plr.cfg]' $USER_HOME/printer_data/config/printer.cfg; then
      echo "[include plr.cfg] is already present in printer.cfg."
  else
      temp_file=$(mktemp)
      echo "[include plr.cfg]" > "$temp_file"
      cat $USER_HOME/printer_data/config/printer.cfg >> "$temp_file"
      mv "$temp_file" $USER_HOME/printer_data/config/printer.cfg

      if grep -q '[include plr.cfg]' $USER_HOME/printer_data/config/printer.cfg; then
          echo "[include plr.cfg] added successfully."
      else
          echo "Error adding [include plr.cfg] to printer.cfg."
      fi
  fi

  if [ ! -f $USER_HOME/printer_data/config/moonraker.conf ]; then
      echo "moonraker.conf does not exist, creating..."
      touch $USER_HOME/printer_data/config/moonraker.conf
  fi

  if grep -Fxq "[include update_royal3d_plr.cfg]" $USER_HOME/printer_data/config/moonraker.conf; then
      echo "[include update_royal3d_plr.cfg] is already present in moonraker.conf."
  else
      temp_file=$(mktemp)
      echo "[include update_royal3d_plr.cfg]" > "$temp_file"
      cat $USER_HOME/printer_data/config/moonraker.conf >> "$temp_file"
      mv "$temp_file" $USER_HOME/printer_data/config/moonraker.conf
  fi

  if [ -f $USER_HOME/printer_data/config/update_royal3d_plr.cfg ]; then
      echo "update_royal3d_plr.cfg already exists, deleting..."
      rm $USER_HOME/printer_data/config/update_royal3d_plr.cfg
  fi

  cat > $USER_HOME/printer_data/config/update_royal3d_plr.cfg << EOF
# Royal3D-PLR update_manager entry
[update_manager Royal3D_PLR]
type: git_repo
path: ~/Royal3D-PLR
origin: https://github.com/Mohammadmdhn/Klipper-Resume-After-Power-Loss.git
primary_branch: main
install_script: install.sh
is_system_service: False
EOF

if [ -n "$SUDO_USER" ]; then
    chown -R "$OWNER":"$OWNER" "$USER_HOME/printer_data/config/"
fi

echo "Royal3D-PLR installation complete."
fi
