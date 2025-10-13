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
