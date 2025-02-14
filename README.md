## Klipper Power Loss Recovery Script

### Introduction
This script is designed to resume a 3D print from the exact height (Z position) after a power outage while using Klipper firmware. It supports popular slicers such as Cura, SuperSlicer, and PrusaSlicer.

Key Features:
- Automatically detects the slicer type.
- Determines the correct Z height for resuming print.
- Recovers nozzle and bed temperatures.
- Restores the extruder position.

---

## Installation and Setup

### 1. Download the Script
Clone the repository to your Raspberry Pi or desired location:
```
git clone https://github.com/Mohammadmdhn/Klipper-Resume-After-Power-Loss.git
```

### 2. Create Necessary Directories
```
mkdir -p /home/pi/printer_data/gcodes/plr/
```

### 3. Edit Slicer Settings

#### Cura:
Add the following to the Post-processing Scripts:
- Insert at Layer Change:
  ```
  LOG_Z
  ```

#### SuperSlicer/PrusaSlicer:
Go to Printer Settings > Custom G-code > Before Layer Change G-code, and add:
```
;Z:[layer_z]
```

### 4. Configure `variables.cfg`
Create the file at `/home/pi/printer_data/config/variables.cfg` with the following content:
```
[Variables]
filepath = ''
last_file = ''
power_resume_z = 0.0
was_interrupted = False
```

### 5. Modify `printer.cfg`
Add the following to your `printer.cfg`:
```
[gcode_macro SAVE_VARIABLE]
variable: VARIABLE
value: VALUE
gcode:
  SET_GCODE_VARIABLE MACRO=SAVE_VARIABLE VARIABLE={params.VARIABLE} VALUE={params.VALUE}
```

---

## Usage

### 1. Start Printing
Print as usual. In case of a power outage:
- Manually update `power_resume_z` in `variables.cfg` with the last known Z height.
- Set `was_interrupted` to `True`.

### 2. Run the Recovery Script
```
bash /path/to/plr.sh
```
The script will generate a new G-code file in `/home/pi/printer_data/gcodes/plr/`.

### 3. Start the Recovered Print
Select and start printing the generated G-code file.

---

## How It Works
- **Detect Slicer:** Determines if the G-code is from Cura or SuperSlicer/PrusaSlicer.
- **Find Resume Height:** Finds the first height after `power_resume_z`.
- **Restore Extruder Position:** Retrieves the last E-value from the G-code.
- **Recover Temperatures:** Extracts bed and nozzle temperatures from the original G-code.

---

## Troubleshooting

### 1. Extrude Only Move Too Long
Increase `max_extrude_only_distance` in `printer.cfg`:
```
[max_extrude_only_distance]
max_distance: 5000
```

### 2. Wrong Resume Height
Ensure you are using the correct syntax for the slicer’s layer change G-code:
- Cura: `LOG_Z`
- SuperSlicer/PrusaSlicer: `;Z:[layer_z]`

---

## Comparison with Similar Projects

| Feature                         | Klipper-Resume-After-Power-Loss | YUMI_PLR  | Klipper-Power-Loss-Recovery |
|----------------------------------|----------------------------------|-----------|------------------------------|
| Multi-Slicer Support            | Yes                              | No        | Limited                     |
| Automatic E-Value Recovery      | Yes                              | No        | Partial                      |
| Bed & Nozzle Temperature Recovery | Yes                           | Partial   | Partial                      |
| Ease of Configuration           | Moderate                         | Easy      | Complex                      |

---

## License
This project is licensed under the MIT License.

---

## Contribution
Contributions are welcome! Feel free to fork the repository and submit pull requests.

---

## Contact
Developed by Mohammad Madahian
Website: [royal3dp.ir](https://royal3dp.ir)
GitHub: [Klipper-Resume-After-Power-Loss](https://github.com/Mohammadmdhn/Klipper-Resume-After-Power-Loss)

---

## راهنمای فارسی

### معرفی
این اسکریپت برای ادامه چاپ سه‌بعدی پس از قطع برق در سیستم Klipper طراحی شده است. از نرم‌افزارهای Cura، SuperSlicer و PrusaSlicer پشتیبانی می‌کند.

### ویژگی‌ها:
- شناسایی خودکار نوع اسلایسر
- تشخیص ارتفاع صحیح Z برای ادامه چاپ
- بازیابی دمای نازل و صفحه
- تنظیم موقعیت اکسترودر

---

## مراحل نصب و راه‌اندازی

### ۱. دانلود اسکریپت
```
git clone https://github.com/Mohammadmdhn/Klipper-Resume-After-Power-Loss.git
```

### ۲. ساخت پوشه لازم
```
mkdir -p /home/pi/printer_data/gcodes/plr/
```

### ۳. تنظیمات در اسلایسر

#### Cura:
در قسمت Post-processing این کد را اضافه کنید:
```
LOG_Z
```

#### SuperSlicer/PrusaSlicer:
در قسمت تنظیمات پرینتر > Custom G-code > Before Layer Change G-code:
```
;Z:[layer_z]
```

### ۴. تنظیم `variables.cfg`
```
[Variables]
filepath = ''
last_file = ''
power_resume_z = 0.0
was_interrupted = False
```

### ۵. افزودن به `printer.cfg`
```
[gcode_macro SAVE_VARIABLE]
variable: VARIABLE
value: VALUE
gcode:
  SET_GCODE_VARIABLE MACRO=SAVE_VARIABLE VARIABLE={params.VARIABLE} VALUE={params.VALUE}
```

---

## نحوه استفاده

۱. چاپ عادی انجام شود.
۲. در صورت قطع برق:
   - مقدار `power_resume_z` را به ارتفاع Z فعلی تغییر دهید.
   - مقدار `was_interrupted` را به `True` تغییر دهید.

۳. اجرای اسکریپت:
```
bash /path/to/plr.sh
```

۴. فایل G-code ایجاد شده را اجرا و چاپ را ادامه دهید.

---

## مشکلات متداول

۱. خطای Extrude Only Move Too Long:
```
[max_extrude_only_distance]
max_distance: 5000
```

۲. ارتفاع شروع اشتباه:
- Cura: `LOG_Z`
- SuperSlicer: `;Z:[layer_z]`

---

## ارتباط
وب‌سایت: [royal3dp.ir](https://royal3dp.ir)
گیت‌هاب: [Klipper-Resume-After-Power-Loss](https://github.com/Mohammadmdhn/Klipper-Resume-After-Power-Loss)

