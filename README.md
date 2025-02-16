# Royal3DP-Klipper-PLR

This repository contains a Bash script designed to automate the process of resuming a 3D print after a power loss when using **Klipper firmware**. The script processes a G-code file and extracts the portion needed to restart printing from the last known layer height.

## Status - Under Development
This project is currently under active development, testing, and bug fixing. If you encounter any issues while using these scripts, please report them. Additionally, if you have any ideas for improvement, feel free to share them with us.

## Key Considerations Before Using
- **Z-axis movement after power loss:** Ensure your Z-axis is manually moved upwards after a power loss before resuming, as leaving it at the same height may cause layer shifts and print failure.
- **X and Y-axis homing accuracy:** Make sure your X and Y axes home precisely without errors. Accurate homing is crucial to ensure the layers align correctly during print resumption.

## Key Features
- Automatically reads the last known Z height from `variables.cfg`.
- Supports G-code files generated by **Cura** and **SuperSlicer/PrusaSlicer**.
- Extracts the remaining G-code starting from the detected Z height.
- Configures initial settings before resuming the print.

## Compatibility Note
This code is currently developed and tested on **MKS PI HSK** systems, with the default working directory set to `mks`. 
If you are using a standard **Raspberry Pi** or another setup (e.g., `pi` user), you need to adjust the paths accordingly in the scripts. 
Compatibility improvements for broader systems will be introduced in future versions.

## Prerequisites
- **Klipper firmware** installed on your 3D printer.
- **Linux environment** (tested on Raspberry Pi OS and MKS PI HSK).
- **`gcodeshellcommand` extension (required for this project)**.
- G-code files with height markers:
  - `;Z:` comments for **SuperSlicer/PrusaSlicer**
  - `LOG_Z` comments for **Cura**

## Installing `gcodeshellcommand` Extension (Required)
The `gcodeshellcommand` extension is necessary for this project to function properly. It allows the execution of shell commands from within G-code files.

### Installation Steps:
1. SSH into your Klipper host (e.g., Raspberry Pi or MKS PI):
    ```bash
    ssh pi@<IP_ADDRESS>
    ```
    Replace `<IP_ADDRESS>` with your printer’s IP address.

2. Navigate to the Klipper directory:
    ```bash
    cd ~/klipper/
    ```

3. Clone the extension repository:
    ```bash
    git clone https://github.com/th33xitus/gcodeshellcommand.git
    ```

4. Edit `moonraker.conf` (usually located in `/home/pi/printer_data/config/moonraker.conf` or `/home/mks/printer_data/config/moonraker.conf` depending on your system):
    ```ini
    [server]
    allow_shell_commands: true
    ```

5. Restart Klipper and Moonraker:
    ```bash
    sudo service klipper restart
    sudo service moonraker restart
    ```

## Installation
```bash
git clone https://github.com/Mohammadmdhn/Royal3DP-Klipper-PLR.git
cd Royal3DP-Klipper-PLR
chmod +x install.sh
sudo ./install.sh
```

## Usage
```bash
./plr_recovery.sh
```
The processed G-code file will be saved in:
```
/home/mks/printer_data/gcodes/plr/<filename>.gcode
```

## Example Output
```
Detected Slicer Type: Cura
Resume Z Height from variables.cfg: 10.200
Cura Mode: Start printing from Z=10.200
Processing complete. Saved to: /home/mks/printer_data/gcodes/plr/<filename>.gcode
```

## Additional Files
This repository includes multiple scripts to assist with power loss recovery. Refer to the `codes/` directory for the latest versions of:
- `plr_recovery.sh`: Main script to resume print after power loss.
- Supporting scripts and utilities (e.g., variable management and setup helpers) will be added as development progresses.

## Important Notes
- This repository is under continuous improvement. Ensure your local copy is up to date.
- Contributions and feedback are welcome.

## Reference
This project is inspired by and based on the work from [YUMI_PLR](https://github.com/Yumi-Lab/YUMI_PLR/tree/main).

## Author
Mohamad Madahiana  
Website: [royal3dp.ir](https://royal3dp.ir)  
LinkedIn: [Mohammad Madahiana](https://www.linkedin.com/in/mohammad-madahian-5ab2b622a/)  
GitHub: [Mohammadmdhn](https://github.com/Mohammadmdhn)  
Contact: +98 9137817673

## License
MIT License

