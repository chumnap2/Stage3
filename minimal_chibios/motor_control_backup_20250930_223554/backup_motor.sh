#!/bin/bash
# === backup_motor.sh: backup project and prepend headers ===

AUTHOR="Chumnap Thach"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
PROJECT_DIR=~/fprime/Stage3/minimal_chibios/motor_control
BACKUP_DIR="${PROJECT_DIR}_backup_$(date '+%Y%m%d_%H%M%S')"

# 1️⃣ Create backup directory
mkdir -p "$BACKUP_DIR"
echo "Project backup will be created in: $BACKUP_DIR"

# 2️⃣ Copy all files into backup
cp -r "$PROJECT_DIR/"* "$BACKUP_DIR/"
echo "All project files copied."

# 3️⃣ Prepend headers to .cpp and .h files
count=0
for f in $(find "$BACKUP_DIR" -type f \( -name "*.cpp" -o -name "*.h" \)); do
    tmpfile=$(mktemp)
    {
        echo "/*"
        echo "Author: $AUTHOR"
        echo "Date: $DATE"
        echo "Description: Motor control project file"
        echo "*/"
        echo
        cat "$f"
    } > "$tmpfile"
    mv "$tmpfile" "$f"
    count=$((count+1))
    echo "[$count] Header added to $(basename "$f")"
done

echo "✅ All headers prepended to .cpp and .h files in backup."
echo "Project fully backed up to: $BACKUP_DIR"
