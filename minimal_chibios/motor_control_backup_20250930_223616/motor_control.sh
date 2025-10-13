#!/bin/bash
# === motor_control.sh: start/stop motor safely with Ctrl+C ===

PROJECT_DIR=~/fprime/Stage3/minimal_chibios/motor_control
BUILD_DIR="$PROJECT_DIR/build"
LOG_FILE="$PROJECT_DIR/motor.log"
PID_FILE="$PROJECT_DIR/motor.pid"

function stop_motor {
    if [ -f "$PID_FILE" ]; then
        kill $(cat "$PID_FILE")
        rm -f "$PID_FILE"
        echo "Motor stopped."
    else
        echo "Motor PID not found. Nothing to stop."
    fi
}

if [ "$1" == "start" ]; then
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    cmake ..
    make

    # Check if already running
    if [ -f "$PID_FILE" ] && ps -p $(cat "$PID_FILE") > /dev/null 2>&1; then
        echo "Motor already running with PID $(cat "$PID_FILE"). Exiting."
        exit 1
    fi

    # Prepare log
    touch "$LOG_FILE"

    # Start daemon
    ./motor_control --daemon &
    sleep 0.3

    if [ ! -f "$PID_FILE" ]; then
        echo "Error: PID file not found. Motor may have exited."
        exit 1
    fi

    echo "Motor started. PID: $(cat "$PID_FILE")"
    echo "Press Ctrl+C to stop motor and exit."

    # Trap Ctrl+C to stop motor
    trap 'echo "Stopping motor..."; stop_motor; exit 0' SIGINT

    tail -f "$LOG_FILE"

elif [ "$1" == "stop" ]; then
    stop_motor
else
    echo "Usage: $0 start|stop"
    exit 1
fi
