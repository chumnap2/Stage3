#!/bin/bash
# -----------------------------------------
# build_and_run.sh
# STM32F407 + minimal ChibiOS (F' Stage3)
# Fully automated toolchain + build
# -----------------------------------------

set -e
set -o pipefail

# -----------------------
# Paths
# -----------------------
PROJECT_DIR="$(pwd)"
BUILD_DIR="$PROJECT_DIR/build"
SOURCE_DIR="$PROJECT_DIR/minimal_chibios"
TOOLCHAIN_FILE="$PROJECT_DIR/toolchain.cmake"

# Detect linker script automatically
LINKER_SCRIPT=""
if [ -f "$SOURCE_DIR/minimal_chibios/stm32f407.ld" ]; then
    LINKER_SCRIPT="$SOURCE_DIR/minimal_chibios/stm32f407.ld"
elif [ -f "$SOURCE_DIR/stm32_flash.ld" ]; then
    LINKER_SCRIPT="$SOURCE_DIR/stm32_flash.ld"
else
    echo "[ERROR] No linker script found in minimal_chibios!"
    exit 1
fi
echo "[INFO] Using linker script: $LINKER_SCRIPT"

# -----------------------
# Generate toolchain.cmake if missing
# -----------------------
if [ ! -f "$TOOLCHAIN_FILE" ]; then
    cat << EOF > "$TOOLCHAIN_FILE"
# -----------------------------
# STM32F407 + minimal ChibiOS Toolchain
# -----------------------------
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections")
set(CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections -fno-exceptions -fno-rtti")
set(CMAKE_EXE_LINKER_FLAGS "-T$LINKER_SCRIPT -mcpu=cortex-m4 -mthumb -Wl,--gc-sections")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
include_directories(
    \${CMAKE_SOURCE_DIR}/minimal_chibios/ChibiOS/os
    \${CMAKE_SOURCE_DIR}/minimal_chibios/ChibiOS/os/hal
)
add_definitions(-D__NEWLIB__ -DCH_CFG_NO_INIT=1)
EOF
    echo "[INFO] Generated toolchain.cmake"
fi

# -----------------------
# Clean build folder
# -----------------------
echo "[INFO] Cleaning previous build..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# -----------------------
# Configure and build
# -----------------------
echo "[INFO] Configuring project with CMake..."
cmake -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE" "$SOURCE_DIR"

echo "[INFO] Building project..."
make -j$(nproc)

# -----------------------
# Optional: Flash placeholder
# -----------------------
# echo "[INFO] Flashing STM32..."
# openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program ${BUILD_DIR}/minimal_chibios.elf verify reset exit"

echo "[INFO] Build complete!"
