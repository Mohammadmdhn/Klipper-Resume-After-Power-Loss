#!/bin/bash
#mohamad_madahiana-royal3dp.ir_09137817673
#https://royal3dp.ir/
#https://www.linkedin.com/in/mohammad-madahian-5ab2b622a/
#https://github.com/Mohammadmdhn
PLR_PATH="/home/mks/printer_data/gcodes/plr/"
mkdir -p "$PLR_PATH"

filepath=$(sed -n "s/.*filepath *= *'\([^']*\)'.*/\1/p" /home/mks/printer_data/config/variables.cfg)
filepath=$(printf "%s" "$filepath")
plr=$(basename "$filepath" | tr ' ' '_' | tr -d '()')

if [ ! -f "$filepath" ]; then
    echo "Error: Unable to open file $filepath"
    exit 1
fi

resume_z=$(sed -n "s/.*power_resume_z *= *\([^ ]*\).*/\1/p" /home/mks/printer_data/config/variables.cfg)
if [ -z "$resume_z" ]; then
    echo "Error: power_resume_z is empty or not found in variables.cfg"
    exit 1
fi

resume_z=$(printf "%.3f" "$resume_z")

echo "Resume Z Height from variables.cfg: $resume_z"

is_superslicer=$(grep -c ";Z:" "$filepath")

if [ "$is_superslicer" -gt 0 ]; then
    slicer_type="SuperSlicer/PrusaSlicer"
else
    slicer_type="Cura"
fi

echo "Detected Slicer Type: $slicer_type"

if [ "$slicer_type" = "SuperSlicer/PrusaSlicer" ]; then
    line_number=$(awk -v resume_z="$resume_z" '$0 ~ /^;Z:/ {z=substr($0,4)+0; if (z >= resume_z - 0.01) {print NR; exit}}' "$filepath")
    if [ -z "$line_number" ]; then
        echo "Error: Could not find Z=$resume_z in G-code for $slicer_type"
        exit 1
    fi
    correct_z=$(awk -v line="$line_number" 'NR==line {sub(/;Z:/,""); print $0}' "$filepath")
    correct_z=$(printf "%.3f" "$correct_z")
    start_line=$line_number
    echo "SuperSlicer/PrusaSlicer Mode: Start printing from Z=$correct_z"
else
    # 
    first_log_line=$(awk -v resume_z="$resume_z" '
    /LOG_Z/ {
        log_line=NR
        getline
        if ($0 ~ /Z[0-9.]+/) {
            match($0, /Z[0-9.]+/)
            z_val=substr($0, RSTART+1, RLENGTH-1)
            z_val_rounded=sprintf("%.3f", z_val)
            if (z_val_rounded == resume_z) {
                print log_line
                exit
            }
        }
    }' "$filepath")

    if [ -z "$first_log_line" ]; then
        echo "Error: Could not find LOG_Z for Z=$resume_z"
        exit 1
    fi

    # 
    second_log_line=$(awk -v start_line="$first_log_line" 'NR > start_line && /LOG_Z/ {print NR; exit}' "$filepath")

    if [ -z "$second_log_line" ]; then
        echo "Error: Could not find the next LOG_Z after line $first_log_line"
        exit 1
    fi

    correct_z=$(awk "NR==$((second_log_line + 1))" "$filepath" | grep -oP 'Z[0-9.]+' | head -1 | sed 's/Z//')

    start_line=$second_log_line

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

sed -i "3iG1 E0.5 F300 ; Prime extruder" "${PLR_PATH}/${plr}"
sed -i "1iSET_KINEMATIC_POSITION Z=${correct_z}" "${PLR_PATH}/${plr}"
sed -i "4iM82 ; Set Extruder to Absolute Mode" "${PLR_PATH}/${plr}"
sed -i "5iG0 F9000 ; Set high speed for initial moves" "${PLR_PATH}/${plr}"

bed_temp=$(grep -m 1 -oP 'M140 S\K\d+' "$filepath")
nozzle_temp=$(grep -m 1 -oP 'M104 S\K\d+' "$filepath")

sed -i "6iM140 S${bed_temp:-0}\nM105\nM190 S${bed_temp:-0}\nM104 S${nozzle_temp:-0}\nM105\nM109 S${nozzle_temp:-0}\nM220 S100\nM221 S100" "${PLR_PATH}/${plr}"

# 
if [ "$slicer_type" = "SuperSlicer/PrusaSlicer" ]; then
    sed -i '0,/^G28$/s//G28 X0 Y0/' "${PLR_PATH}/${plr}"
fi

echo "Processing complete. Saved to: ${PLR_PATH}/${plr}"
