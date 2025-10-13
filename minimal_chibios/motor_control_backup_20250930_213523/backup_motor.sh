#!/bin/bash

# --- Configuration ---
AUTHOR="Chumnap Thach"
DATE=$(date '+%Y-%m-%d')
DESC="Motor control minimal ChibiOS project"

PROJECT_DIR=~/fprime/Stage3/minimal_chibios/motor_control
BACKUP_DIR=~/fprime/Stage3/minimal_chibios/motor_control_backup_$(date '+%Y%m%d_%H%M%S')

# --- Create backup folder ---
mkdir -p "$BACKUP_DIR"
cp -r "$PROJECT_DIR/"* "$BACKUP_DIR/"
echo "Project backed up to $BACKUP_DIR"

# --- Prepend header to each .cpp and .h file ---
FILES=$(find "$BACKUP_DIR" -type f \( -name "*.cpp" -o -name "*.h" \))
TOTAL=$(echo "$FILES" | wc -l)
COUNT=0

for f in $FILES; do
    COUNT=$((COUNT+1))
    tmpfile=$(mktemp)
    {
        echo "/*"
        echo "Author: $AUTHOR"
        echo "Date: $DATE"
        echo "Description: $DESC"
        echo "File: $(basename "$f")"
        echo "*/"
        echo
        cat "$f"
    } > "$tmpfile"
    mv "$tmpfile" "$f"
    echo "[$COUNT/$TOTAL] Header added to $(basename "$f")"
done

echo "All headers prepended to .cpp and .h files in backup."
