#!/bin/bash
#mohamad_madahiana-royal3dp.ir_09137817673

PLR_PATH="/home/pi/printer_data/gcodes/plr/"
mkdir -p "$PLR_PATH"

filepath=$(sed -n "s/.*filepath *= *'\([^']*\)'.*/\1/p" /home/pi/printer_data/config/variables.cfg)
filepath=$(printf "%s" "$filepath")
plr=$(basename "$filepath")

if [ ! -f "$filepath" ]; then
    echo "Error: Unable to open file $filepath"
    exit 1
fi

resume_z=$(sed -n "s/.*power_resume_z *= *\([^ ]*\).*/\1/p" /home/pi/printer_data/config/variables.cfg)
if [ -z "$resume_z" ]; then
    echo "Error: power_resume_z is empty or not found in variables.cfg"
    exit 1
fi

resume_z=$(printf "%.2f" "$resume_z")

echo "Resume Z Height from variables.cfg: $resume_z"

is_superslicer=$(grep -c ";Z:" "$filepath")

if [ "$is_superslicer" -gt 0 ]; then
    slicer_type="SuperSlicer/PrusaSlicer"
else
    slicer_type="Cura"
fi

echo "Detected Slicer Type: $slicer_type"

if [ "$slicer_type" = "SuperSlicer/PrusaSlicer" ]; then
    line_number=$(grep -n ";Z:$resume_z" "$filepath" | cut -d: -f1 | head -1)
    if [ -z "$line_number" ]; then
        echo "Error: Could not find Z=$resume_z in G-code for $slicer_type"
        exit 1
    fi
    start_line=$line_number
    correct_z=$resume_z
    echo "SuperSlicer/PrusaSlicer Mode: Start printing from Z=$correct_z"
else
    start_line=$(awk -v resume_z="$resume_z" '
    /LOG_Z/ {
        z_found=0
        while ((getline) > 0) {
            if ($0 ~ /[Gg][01].* Z[0-9.]+/) {
                match($0, / Z[0-9.]+/)
                z_val=substr($0, RSTART+2, RLENGTH-2)
                z_val_rounded=sprintf("%.2f", z_val)
                if (z_val_rounded == resume_z) {
                    z_found=1
                    continue
                }
                if (z_found && z_val_rounded > resume_z) {
                    print NR
                    exit
                }
            }
        }
    }' "$filepath")

    if [ -z "$start_line" ]; then
        echo "Error: Could not find next layer after Z=$resume_z"
        exit 1
    fi

    correct_z=$(awk "NR==$start_line" "$filepath" | grep -oP 'Z[0-9.]*' | head -1 | sed 's/Z//')

    if [ -z "$correct_z" ]; then
        correct_z=$resume_z
        echo "Warning: No Z height found on start line. Using resume_z=$correct_z"
    fi

    echo "Cura Mode: Resume Z Height is $resume_z but actual Z for start is $correct_z"
    echo "Start printing from Z=$correct_z"
fi

echo "Start printing from line: $start_line"

tail -n +"$start_line" "$filepath" > "${PLR_PATH}/${plr}"

if [ "$slicer_type" = "Cura" ]; then
    e_value=$(awk "NR>=$((start_line-10)) && NR<=$((start_line+10))" "$filepath" | grep -oP 'E[0-9.]*' | tail -1 | sed 's/E//')
    if [ -z "$e_value" ]; then
        e_value=0
    fi
    sed -i "2iG92 E$e_value ; Reset Extruder Position" "${PLR_PATH}/${plr}"
else
    sed -i "2iG92 E0 ; Reset Extruder Position" "${PLR_PATH}/${plr}"
fi

sed -i "1iSET_KINEMATIC_POSITION Z=${correct_z}" "${PLR_PATH}/${plr}"
sed -i "3iM82 ; Set Extruder to Absolute Mode" "${PLR_PATH}/${plr}"
sed -i "4iG0 F9000 ; Set high speed for initial moves" "${PLR_PATH}/${plr}"

bed_temp=$(grep -m 1 -oP 'M140 S\K\d+' "$filepath")
nozzle_temp=$(grep -m 1 -oP 'M104 S\K\d+' "$filepath")

sed -i "/M201/d" "${PLR_PATH}/${plr}"
sed -i "/M203/d" "${PLR_PATH}/${plr}"
sed -i "/M204/d" "${PLR_PATH}/${plr}"
sed -i "/M205/d" "${PLR_PATH}/${plr}"

sed -i "5iM140 S${bed_temp:-70}\nM105\nM190 S${bed_temp:-70}\nM104 S${nozzle_temp:-245}\nM105\nM109 S${nozzle_temp:-245}\nM220 S100\nM221 S100" "${PLR_PATH}/${plr}"

echo "Processing complete. Saved to: ${PLR_PATH}/${plr}"
