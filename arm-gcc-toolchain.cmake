# Toolchain file for STM32 / ChibiOS Stage3

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Compilers
set(CMAKE_C_COMPILER   arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Compilation flags for Cortex-M4 (adjust if using a different STM32)
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall")
set(CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall")
set(CMAKE_ASM_FLAGS "-mcpu=cortex-m4 -mthumb")

# Linker
set(CMAKE_EXE_LINKER_FLAGS "-T${CMAKE_SOURCE_DIR}/stm32_flash.ld")
