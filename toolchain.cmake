# -----------------------------
# STM32 + minimal ChibiOS Toolchain
# -----------------------------

# Target system
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Cross compilers
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)

# Compiler flags for Cortex-M4
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections")
set(CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections -fno-exceptions -fno-rtti")

# Linker flags (MCU flags only, no -T)
set(CMAKE_EXE_LINKER_FLAGS "-mcpu=cortex-m4 -mthumb -Wl,--gc-sections")

# Prevent CMake from trying to run test executables
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Include directories (adjust if needed)
include_directories(
    ${CMAKE_SOURCE_DIR}/ChibiOS/os
    ${CMAKE_SOURCE_DIR}/ChibiOS/os/hal
)

# Minimal syscalls (needed for newlib)
add_definitions(-D__NEWLIB__ -DCH_CFG_NO_INIT=1)
