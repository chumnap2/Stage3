#!/bin/bash
# ======================================================
# Stage3 Generator: STM32F407 + minimal ChibiOS + UART + LED
# Fully automatic, sets include paths correctly
# ======================================================

set -e

ROOT_DIR="Stage3"
CHIBIOS_DIR="$ROOT_DIR/ChibiOS"
CHIBIOS_OS="$CHIBIOS_DIR/os"

echo "[INFO] Creating project structure..."
mkdir -p "$ROOT_DIR/minimal_chibios/src" "$ROOT_DIR/minimal_chibios/include"

# ------------------------------------------------------
# 1️⃣ Download minimal ChibiOS if missing
# ------------------------------------------------------
if [ ! -d "$CHIBIOS_DIR" ]; then
    echo "[INFO] Downloading minimal ChibiOS..."
    git clone --depth 1 https://github.com/ChibiOS/ChibiOS.git "$CHIBIOS_DIR"
fi

# ------------------------------------------------------
# 2️⃣ toolchain.cmake with correct include paths
# ------------------------------------------------------
cat > "$ROOT_DIR/toolchain.cmake" << EOF
# STM32 + minimal ChibiOS Toolchain
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections")
set(CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections -fno-exceptions -fno-rtti")
set(CMAKE_EXE_LINKER_FLAGS "-T\${CMAKE_SOURCE_DIR}/stm32f407.ld -mcpu=cortex-m4 -mthumb -Wl,--gc-sections")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Include directories for ChibiOS (auto-detected)
include_directories(
    \${CMAKE_SOURCE_DIR}/../ChibiOS/os      # ch.hpp
    \${CMAKE_SOURCE_DIR}/../ChibiOS/os/hal  # hal.h
)

# Minimal syscalls
add_definitions(-D__NEWLIB__ -DCH_CFG_NO_INIT=1)
EOF

# ------------------------------------------------------
# 3️⃣ CMakeLists.txt
# ------------------------------------------------------
cat > "$ROOT_DIR/minimal_chibios/CMakeLists.txt" << 'EOF'
cmake_minimum_required(VERSION 3.20)
project(minimal_chibios C CXX)

set(SRC_FILES
    src/main.cpp
    src/led.cpp
    src/uart.cpp
)

set(INCLUDE_DIRS
    include
)

add_executable(minimal_chibios.elf ${SRC_FILES})
target_include_directories(minimal_chibios.elf PRIVATE ${INCLUDE_DIRS})
EOF

# ------------------------------------------------------
# 4️⃣ LED + UART headers & sources
# ------------------------------------------------------
cat > "$ROOT_DIR/minimal_chibios/include/led.hpp" << 'EOF'
#pragma once
#include "hal.h"
void toggle_led();
EOF

cat > "$ROOT_DIR/minimal_chibios/src/led.cpp" << 'EOF'
#include "led.hpp"
void toggle_led() {
    palTogglePad(GPIOD, GPIOD_LED3);
}
EOF

cat > "$ROOT_DIR/minimal_chibios/include/uart.hpp" << 'EOF'
#pragma once
void uart_send(const char* msg);
EOF

cat > "$ROOT_DIR/minimal_chibios/src/uart.cpp" << 'EOF'
#include "hal.h"
#include "uart.hpp"
#include <string.h>
void uart_send(const char* msg) {
    sdWrite(&SD2, (const uint8_t*)msg, strlen(msg));
    sdWrite(&SD2, (const uint8_t*)"\r\n", 2);
}
EOF

# ------------------------------------------------------
# 5️⃣ main.cpp
# ------------------------------------------------------
cat > "$ROOT_DIR/minimal_chibios/src/main.cpp" << 'EOF'
#include "ch.hpp"
#include "hal.h"
#include "led.hpp"
#include "uart.hpp"

int main(void) {
    halInit();
    chSysInit();
    palSetPadMode(GPIOD, GPIOD_LED3, PAL_MODE_OUTPUT_PUSHPULL);

    static SerialConfig uart_cfg = {115200, 0, 0, 0};
    sdStart(&SD2, &uart_cfg);

    while (true) {
        toggle_led();
        uart_send("Stage3 is alive! 🎉");
        chThdSleepMilliseconds(500);
    }
}
EOF

# ------------------------------------------------------
# 6️⃣ Minimal linker script
# ------------------------------------------------------
cat > "$ROOT_DIR/minimal_chibios/stm32f407.ld" << 'EOF'
MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 192K
}
SECTIONS
{
  .text : { *(.text*) } > FLASH
  .data : { *(.data*) } > RAM
  .bss  : { *(.bss*)  } > RAM
}
EOF

# ------------------------------------------------------
# 7️⃣ build_and_run.sh
# ------------------------------------------------------
cat > "$ROOT_DIR/build_and_run.sh" << 'EOF'
#!/bin/bash
set -e
echo "[INFO] Cleaning previous build..."
rm -rf minimal_chibios/build
mkdir -p minimal_chibios/build && cd minimal_chibios/build
echo "[INFO] Configuring project with CMake..."
cmake .. -DCMAKE_TOOLCHAIN_FILE=../../toolchain.cmake
echo "[INFO] Building project..."
make -j$(nproc)
echo "[INFO] Build complete!"
if [ "$1" == "flash" ]; then
    echo "[INFO] Flashing STM32F407..."
    openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
        -c "program minimal_chibios.elf verify reset exit"
    echo "[INFO] Flash complete! 🎉"
fi
EOF

chmod +x "$ROOT_DIR/build_and_run.sh"

echo "[SUCCESS] Stage3 project fully generated!"
echo "→ cd $ROOT_DIR && ./build_and_run.sh flash to build & flash your STM32F407 🎉"
