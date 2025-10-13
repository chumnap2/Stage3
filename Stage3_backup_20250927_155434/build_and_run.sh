#!/bin/bash
set -e

PROJECT_DIR=$(pwd)
BUILD_DIR="$PROJECT_DIR/minimal_chibios/build"
TOOLCHAIN_FILE="$PROJECT_DIR/arm-gcc-toolchain.cmake"
MAIN_CPP="$PROJECT_DIR/minimal_chibios/src/main.cpp"
LINKER_SCRIPT="$PROJECT_DIR/minimal_chibios/stm32_flash.ld"
SYS_CALLS="$PROJECT_DIR/minimal_chibios/src/syscalls.c"

echo "📋 Checking essential files..."
if [[ ! -f "$MAIN_CPP" ]]; then
    echo "❌ Essential file missing: $MAIN_CPP"
    echo "⚠️ Build aborted. No backup was made."
    exit 1
fi

if [[ ! -f "$LINKER_SCRIPT" ]]; then
    echo "❌ Linker script missing: $LINKER_SCRIPT"
    echo "⚠️ Build aborted. No backup was made."
    exit 1
fi

# Create backup only if build will proceed
BACKUP_DIR="$PROJECT_DIR/Stage3_backup_$(date +%Y%m%d_%H%M%S)"
echo "📦 Backing up Stage3..."
mkdir -p "$BACKUP_DIR"
rsync -a --exclude 'build' "$PROJECT_DIR/" "$BACKUP_DIR/"
echo "✅ Backup completed at $BACKUP_DIR"

# Check or create toolchain file
echo "📋 Checking ARM toolchain file..."
if [[ ! -f "$TOOLCHAIN_FILE" ]]; then
    echo "⚠️ Toolchain file missing, creating..."
    cat <<EOT > "$TOOLCHAIN_FILE"
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
EOT
    echo "✅ Toolchain file created at $TOOLCHAIN_FILE"
fi

# Check minimal syscalls
if [[ ! -f "$SYS_CALLS" ]]; then
    echo "⚠️ Syscalls file missing, creating minimal syscalls.c..."
    cat <<'EOF' > "$SYS_CALLS"
#include <sys/stat.h>
#include <sys/types.h>
int _write(int file, char *ptr, int len) { return len; }
int _read(int file, char *ptr, int len) { return 0; }
caddr_t _sbrk(int incr) { return 0; }
void _exit(int status) { while(1); }
int _close(int file) { return -1; }
int _lseek(int file, int ptr, int dir) { return 0; }
int _fstat(int file, struct stat *st) { st->st_mode = S_IFCHR; return 0; }
int _isatty(int file) { return 1; }
EOF
    echo "✅ Minimal syscalls created at $SYS_CALLS"
fi

# Clean build directory
echo "🧹 Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure CMake
echo "⚙️ Configuring CMake..."
cmake .. -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE"

# Build
echo "⚙️ Building project..."
cmake --build . -- -j$(nproc)

echo "✅ Build completed successfully!"
