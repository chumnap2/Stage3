# STM32F4 cross-compile toolchain for CMake

# Specify the cross compiler
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER   arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)

# Target CPU options
set(CPU_FLAGS "-mcpu=cortex-m4 -mthumb")
set(CMAKE_C_FLAGS   "${CPU_FLAGS} -O2 -Wall -std=gnu11")
set(CMAKE_CXX_FLAGS "${CPU_FLAGS} -O2 -Wall -std=c++17")

# Linker script
set(LINKER_SCRIPT "${CMAKE_CURRENT_LIST_DIR}/STM32F4XX.ld")
set(CMAKE_EXE_LINKER_FLAGS "-T${LINKER_SCRIPT} -Wl,--gc-sections")

# General options
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
