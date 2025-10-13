#!/bin/bash
# ==============================
# build_and_run.sh - Safe Build Script for Stage3 + ChibiOS
# ==============================

set -e  # Exit on first error

# ------------------------------
# Paths
# ------------------------------
PROJECT_DIR="$(pwd)"
BACKUP_DIR="$PROJECT_DIR/Stage3_backup_$(date +%Y%m%d_%H%M%S)"
CHIBIOS_DIR="$PROJECT_DIR/ChibiOS_F4_full"
MINIMAL_CHIBIOS="$PROJECT_DIR/minimal_chibios"

# ------------------------------
# Check essential files
# ------------------------------
ESSENTIAL_FILES=(
    "$MINIMAL_CHIBIOS/src/main.cpp"
)

for f in "${ESSENTIAL_FILES[@]}"; do
    if [ ! -f "$f" ]; then
        echo "❌ Essential file missing: $f"
        echo "⚠️ Build aborted. No backup was made."
        exit 1
    fi
done

# ------------------------------
# Backup current project safely
# ------------------------------
echo "📦 Backing up Stage3..."
mkdir -p "$BACKUP_DIR"
rsync -a --exclude 'Stage3_backup_*' "$PROJECT_DIR/" "$BACKUP_DIR/"
echo "✅ Backup completed at $BACKUP_DIR"

# ------------------------------
# Ensure ChibiOS config headers exist
# ------------------------------
echo "📋 Ensuring ChibiOS config headers exist..."

# Create minimal_chibios/src if missing
mkdir -p "$MINIMAL_CHIBIOS/src"

# chconf.h
if [ ! -f "$MINIMAL_CHIBIOS/src/chconf.h" ]; then
    if [ -f "$CHIBIOS_DIR/os/rt/templates/chconf.h" ]; then
        cp "$CHIBIOS_DIR/os/rt/templates/chconf.h" "$MINIMAL_CHIBIOS/src/"
        echo "✅ Copied chconf.h template"
    else
        touch "$MINIMAL_CHIBIOS/src/chconf.h"
        echo "⚠️ Created minimal chconf.h (template missing)"
    fi
fi

# halconf.h
if [ ! -f "$MINIMAL_CHIBIOS/src/halconf.h" ]; then
    if [ -f "$CHIBIOS_DIR/os/hal/templates/halconf.h" ]; then
        cp "$CHIBIOS_DIR/os/hal/templates/halconf.h" "$MINIMAL_CHIBIOS/src/"
        echo "✅ Copied halconf.h template"
    else
        touch "$MINIMAL_CHIBIOS/src/halconf.h"
        echo "⚠️ Created minimal halconf.h (template missing)"
    fi
fi

# mcuconf.h
if [ ! -f "$MINIMAL_CHIBIOS/src/mcuconf.h" ]; then
    # Try board-specific first
    BOARD_MCUCONF="$CHIBIOS_DIR/os/hal/boards/ST_STM32F4_DISCOVERY/mcuconf.h"
    if [ -f "$BOARD_MCUCONF" ]; then
        cp "$BOARD_MCUCONF" "$MINIMAL_CHIBIOS/src/mcuconf.h"
        echo "✅ Copied board-specific mcuconf.h"
    elif [ -f "$CHIBIOS_DIR/os/hal/templates/mcuconf.h" ]; then
        cp "$CHIBIOS_DIR/os/hal/templates/mcuconf.h" "$MINIMAL_CHIBIOS/src/"
        echo "✅ Copied mcuconf.h template"
    else
        touch "$MINIMAL_CHIBIOS/src/mcuconf.h"
        echo "⚠️ Created minimal mcuconf.h (template missing)"
    fi
fi

# ------------------------------
# Clean build directory
# ------------------------------
echo "🧹 Cleaning build directory..."
rm -rf "$MINIMAL_CHIBIOS/build"
mkdir -p "$MINIMAL_CHIBIOS/build"

# ------------------------------
# Compile sources
# ------------------------------
echo "⚙️ Compiling sources..."
cd "$MINIMAL_CHIBIOS/build"

# Example build command - adjust for your toolchain
if command -v make &> /dev/null; then
    make -C "$MINIMAL_CHIBIOS/src" all
else
    echo "⚠️ Make not found. Please install make and your ARM toolchain."
    exit 1
fi

echo "✅ Build finished successfully"
