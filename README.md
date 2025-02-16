# Royal3DP-Klipper-PLR

Royal3DP-Klipper-PLR is a comprehensive solution developed to ensure 3D printing continuity after power loss using **Klipper firmware**. This project processes G-code files and automatically resumes prints from the last recorded layer height.

## Current Status - Under Development
This project is actively being developed, tested, and refined. If you experience any issues, or have suggestions for improvements, please submit an issue or pull request on GitHub.

## Key Considerations Before Use
- **Z-axis Position Adjustment:** After a power loss, manually raise the Z-axis before resuming to prevent nozzle collisions and layer misalignment.
- **X and Y Homing Accuracy:** Ensure that X and Y homing is precise to avoid layer shifts during resumption.

## Key Features
- Automatically detects the last known Z height from `variables.cfg`.
- Supports G-code from both **Cura** and **SuperSlicer/PrusaSlicer**.
- Extracts and processes G-code from the detected layer height onward.
- Includes validation checks to minimize print errors during recovery.
- Restores extruder position based on slicer type.

## Compatibility
Tested on:
- **MKS PI HSK**
- **Raspberry Pi (with Klipper)**

Default configurations are optimized for `mks` user. If you are using `pi` or any other user, please update the paths in the scripts accordingly.

## Prerequisites
- **Klipper firmware** installed on your 3D printer.
- **Linux environment** (Tested on Raspberry Pi OS and MKS PI HSK).
- `gcodeshellcommand` extension enabled in Klipper.
- G-code files with:
  - `;Z:` comments for **SuperSlicer/PrusaSlicer**.
  - `LOG_Z` comments for **Cura**.

## Installing `gcodeshellcommand` Extension
This project requires `gcodeshellcommand` for executing shell commands via G-code in Klipper.

### Steps:
```bash
ssh mks@<IP_ADDRESS>
cd ~/klipper/
git clone https://github.com/th33xitus/gcodeshellcommand.git
```

Add the following to `moonraker.conf`:
```ini
[server]
allow_shell_commands: true
```

Restart Klipper and Moonraker:
```bash
sudo service klipper restart
sudo service moonraker restart
```

## Installation
Run the following command in your terminal:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mohammadmdhn/Royal3DP-Klipper-PLR/main/install.sh)"
```

This will:
- Copy necessary configuration files to the appropriate directories.
- Modify `printer.cfg` and `moonraker.conf` to include the necessary configurations.
- Set permissions for shell scripts.

## Uninstallation
Run the following command in your terminal:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mohammadmdhn/Royal3DP-Klipper-PLR/main/uninstall.sh)"
```
This will remove:
- Configuration files (plr.cfg, update_royal3d_plr.cfg).
- gcode_shell_command.py extension.
- Directory and script files related to PLR.

## Usage
Once installed, after a power loss, run this command in your Klipper console:
```gcode
RESUME_INTERRUPTED
```
This will:
1. Extract the remaining G-code from the last saved Z height.
2. Prepare the print environment (heaters, extruder position, etc.).
3. Resume the print from the correct height.

The processed G-code file will be saved in:
```
/home/mks/printer_data/gcodes/plr/<filename>.gcode
```

## Example Console Output
```
Detected Slicer Type: Cura
Resume Z Height from variables.cfg: 10.200
Cura Mode: Start printing from Z=10.200
Processing complete. Saved to: /home/mks/printer_data/gcodes/plr/<filename>.gcode
```

## Troubleshooting and Validation
- Ensure the Z-axis is physically raised after power loss before running `RESUME_INTERRUPTED`.
- Ensure X and Y axes home accurately.
- Cura users: Add `LOG_Z` after each layer change.
- Verify `variables.cfg` is correctly updated after every print.

## File Descriptions
- `plr.sh` - Main script for processing G-code after power loss.
- `install.sh` - Installation script to set up the environment.
- `uninstall.sh` - Uninstallation script to remove all related files.
- `gcode_shell_command.py` - Enables shell commands from G-code.
- `clear_plr.sh` - Clears variables in `variables.cfg`.
- `plr.cfg` - Klipper macro configuration.

## License
This project is licensed under the MIT License.

## Acknowledgments
This project is inspired by and builds upon the work from [YUMI_PLR](https://github.com/Yumi-Lab/YUMI_PLR).

## Contact
- **Author:** Mohamad Madahiana
- **Website:** [royal3dp.ir](https://royal3dp.ir)
- **GitHub:** [Mohammadmdhn](https://github.com/Mohammadmdhn)
- **LinkedIn:** [Mohammad Madahiana](https://www.linkedin.com/in/mohammad-madahian-5ab2b622a/)
- **Contact:** +98 9137817673

---

## توضیحات فارسی:
پروژه Royal3DP-Klipper-PLR برای بازیابی و ادامه چاپ بعد از قطع برق در پرینترهای سه‌بعدی مبتنی بر Klipper توسعه داده شده است.

### ویژگی‌ها:
- پشتیبانی از نرم‌افزارهای **Cura** و **SuperSlicer/PrusaSlicer**
- تشخیص خودکار ارتفاع قطع شده و شروع ادامه چاپ
- جلوگیری از برخورد نازل با قطعه بعد از قطع برق
- تنظیم دقیق اکسترودر بعد از قطع برق
- نصب خودکار با اسکریپت

### نصب:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Mohammadmdhn/Royal3DP-Klipper-PLR/main/install.sh)"
```

### راه‌اندازی ادامه چاپ:
پس از نصب، در صورت قطع برق و برگشت دستگاه، از طریق کنسول فرمان زیر را اجرا کنید:
```gcode
RESUME_INTERRUPTED
```

### توسعه‌دهنده:
محمد مداحیان  
[Royal3DP.ir](https://royal3dp.ir) | 09137817673  
[لینکدین](https://www.linkedin.com/in/mohammad-madahian-5ab2b622a/) | [گیت‌هاب](https://github.com/Mohammadmdhn)

