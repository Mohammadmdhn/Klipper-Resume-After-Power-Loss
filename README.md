# Klipper-Resume-After-Power-Loss
Klipper Power Loss Recovery Script – Resume 3D printing after a power outage. Supports Cura, SuperSlicer, and PrusaSlicer.
# Klipper Power Loss Resume (FA)
A robust power loss recovery solution for Klipper firmware. This script helps your 3D printer to resume printing from the exact layer after a power outage. Compatible with **Cura**, **SuperSlicer**, and **PrusaSlicer**.

## Features
- Automatic layer detection and resume.
- Supports different slicers.
- Restores bed and nozzle temperatures.
- Resets extruder position based on last E-value.

## Installation & Usage
1. Copy `plr.sh` script to your Raspberry Pi.
2. Add `LOG_Z` to your slicer's "After Layer Change G-code".
3. In case of power loss, run `plr.sh` to generate the recovery G-code.
4. Start the print using the new G-code file.

---

# از سرگیری پرینت بعد از قطع برق در کلیپر (FA)
این اسکریپت برای ادامه پرینت در صورت قطع برق طراحی شده است. با فریمور **Klipper** و نرم‌افزارهای اسلایسر **Cura**، **SuperSlicer** و **PrusaSlicer** سازگار است.

## ویژگی‌ها
- تشخیص خودکار لایه و ادامه پرینت.
- پشتیبانی از چندین اسلایسر.
- بازیابی دمای نازل و صفحه.
- تنظیم مجدد موقعیت اکسترودر.

## نصب و استفاده
1. فایل `plr.sh` را به رزبری‌پای خود منتقل کنید.
2. در قسمت "After Layer Change G-code" دستور `LOG_Z` را اضافه کنید.
3. در صورت قطع برق، اسکریپت `plr.sh` را اجرا کنید.
4. از فایل جی‌کد جدید پرینت را ادامه دهید.
