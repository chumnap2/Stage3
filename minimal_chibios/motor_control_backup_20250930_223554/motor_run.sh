#!/bin/bash
# === motor_run.sh: build + start motor daemon + tail log ===

PROJECT_DIR=~/fprime/Stage3/minimal_chibios/motor_control
BUILD_DIR="$PROJECT_DIR/build"
LOG_FILE="$PROJECT_DIR/motor.log"
PID_FILE="$PROJECT_DIR/motor.pid"

# 1️⃣ Build project
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
cmake ..
make

# 2️⃣ Prepare log and PID files
rm -f "$LOG_FILE" "$PID_FILE"
touch "$LOG_FILE"

# 3️⃣ Start motor in daemon mode
./motor_control --daemon &

# Wait briefly for PID file to be created
sleep 0.2
if [ -f "$PID_FILE" ]; then
    echo "Motor running as PID $(cat $PID_FILE)"
else
    echo "Warning: PID file not found. Motor may have exited."
fi

# 4️⃣ Tail log
echo "Tailing log: $LOG_FILE"
tail -f "$LOG_FILE"
