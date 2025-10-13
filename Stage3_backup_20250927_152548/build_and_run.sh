#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Paths
PROJECT_DIR="$(pwd)"
MINIMAL_CHIBIOS="$PROJECT_DIR/minimal_chibios/src"
CHIBIOS_FULL="$PROJECT_DIR/ChibiOS_F4_full"
BACKUP_DIR="$PROJECT_DIR/Stage3_backup_$(date +%Y%m%d_%H%M%S)"

# Essential files check
ESSENTIAL_FILES=(
    "$MINIMAL_CHIBIOS/main.cpp"
)

for f in "${ESSENTIAL_FILES[@]}"; do
    if [ ! -f "$f" ]; then
        echo "❌ Essential file missing: $f"
        echo "⚠️ Build aborted. No backup was made."
        exit 1
    fi
done

# Backup current project
echo "📦 Backing up Stage3..."
mkdir -p "$BACKUP_DIR"
cp -r "$PROJECT_DIR/"* "$BACKUP_DIR/"
echo "✅ Backup completed at $BACKUP_DIR"

# Ensure ChibiOS config headers
echo "📋 Ensuring ChibiOS config headers exist..."
mkdir -p "$MINIMAL_CHIBIOS"

# chconf.h
if [ -f "$CHIBIOS_FULL/os/rt/templates/chconf.h" ]; then
    cp "$CHIBIOS_FULL/os/rt/templates/chconf.h" "$MINIMAL_CHIBIOS/chconf.h"
else
    touch "$MINIMAL_CHIBIOS/chconf.h"
    echo "⚠️ Created minimal chconf.h (full template missing)"
fi

# halconf.h
if [ -f "$CHIBIOS_FULL/os/hal/templates/halconf.h" ]; then
    cp "$CHIBIOS_FULL/os/hal/templates/halconf.h" "$MINIMAL_CHIBIOS/halconf.h"
else
    touch "$MINIMAL_CHIBIOS/halconf.h"
    echo "⚠️ Created minimal halconf.h (full template missing)"
fi

# mcuconf.h
if [ -f "$CHIBIOS_FULL/os/hal/boards/ST_STM32F4_DISCOVERY/mcuconf.h" ]; then
    cp "$CHIBIOS_FULL/os/hal/boards/ST_STM32F4_DISCOVERY/mcuconf.h" "$MINIMAL_CHIBIOS/mcuconf.h"
else
    touch "$MINIMAL_CHIBIOS/mcuconf.h"
    echo "⚠️ Created minimal mcuconf.h (full template missing)"
fi

# Clean build directory
echo "🧹 Cleaning build directory..."
rm -rf "$MINIMAL_CHIBIOS/build"
mkdir -p "$MINIMAL_CHIBIOS/build"

# Compile sources
echo "⚙️ Compiling sources..."
cd "$MINIMAL_CHIBIOS/build"

# Adjust this compiler command to match your F'/ChibiOS setup
# Example for arm-none-eabi g++
arm-none-eabi-g++ -std=gnu++14 -I"$MINIMAL_CHIBIOS" -I"$CHIBIOS_FULL/os/rt/include" \
    "$MINIMAL_CHIBIOS/main.cpp" -o main.elf

# Link ELF (adjust linker script if needed)
echo "🔗 Linking ELF..."
arm-none-eabi-ld -T "$PROJECT_DIR/stm32_flash.ld" main.elf -o main.elf

# Generate binary
echo "📦 Generating BIN..."
arm-none-eabi-objcopy -O binary main.elf main.bin

echo "✅ Build completed successfully!"
