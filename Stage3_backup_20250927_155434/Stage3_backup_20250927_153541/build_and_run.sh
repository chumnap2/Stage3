#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

PROJECT_DIR=$(pwd)
MINIMAL_CHIBIOS="$PROJECT_DIR/minimal_chibios"
BUILD_DIR="$MINIMAL_CHIBIOS/build"
CHIBIOS_DIR="$PROJECT_DIR/ChibiOS_F4_full"

# === Safety check ===
if [ ! -f "$MINIMAL_CHIBIOS/src/main.cpp" ]; then
    echo "❌ Essential file missing: $MINIMAL_CHIBIOS/src/main.cpp"
    echo "⚠️ Build aborted. No backup was made."
    exit 1
fi

# === Backup ===
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$PROJECT_DIR/Stage3_backup_$TIMESTAMP"
echo "📦 Backing up Stage3..."
mkdir -p "$BACKUP_DIR"
rsync -a --exclude 'build/' "$PROJECT_DIR/" "$BACKUP_DIR"
echo "✅ Backup completed at $BACKUP_DIR"

# === Ensure ChibiOS config headers exist ===
echo "📋 Ensuring ChibiOS config headers exist..."
CONFIG_SRC="$MINIMAL_CHIBIOS/src"
mkdir -p "$CONFIG_SRC"

# Copy templates if they exist
[ -f "$CHIBIOS_DIR/os/rt/templates/chconf.h" ] && cp "$CHIBIOS_DIR/os/rt/templates/chconf.h" "$CONFIG_SRC/chconf.h" || echo "⚠️ chconf.h template missing"
[ -f "$CHIBIOS_DIR/os/hal/templates/halconf.h" ] && cp "$CHIBIOS_DIR/os/hal/templates/halconf.h" "$CONFIG_SRC/halconf.h" || echo "⚠️ halconf.h template missing"
[ -f "$CHIBIOS_DIR/os/hal/templates/mcuconf.h" ] && cp "$CHIBIOS_DIR/os/hal/templates/mcuconf.h" "$CONFIG_SRC/mcuconf.h" || echo "⚠️ mcuconf.h template missing"

# === Build ===
echo "🧹 Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "⚙️ Configuring CMake..."
cmake -DCMAKE_TOOLCHAIN_FILE="$PROJECT_DIR/arm-gcc-toolchain.cmake" ..

echo "🔨 Compiling sources..."
cmake --build . -- -j$(nproc)

# === Output ===
if [ -f "$BUILD_DIR/main.elf" ]; then
    echo "✅ Build successful!"
    # Optional: generate binary for flashing
    arm-none-eabi-objcopy -O binary "$BUILD_DIR/main.elf" "$BUILD_DIR/main.bin" && echo "📦 main.bin created"
else
    echo "❌ Build failed!"
    exit 1
fi
