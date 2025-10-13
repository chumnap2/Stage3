# STM32 + minimal ChibiOS Toolchain
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections")
set(CMAKE_CXX_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall -fdata-sections -ffunction-sections -fno-exceptions -fno-rtti")
set(CMAKE_EXE_LINKER_FLAGS "-T${CMAKE_SOURCE_DIR}/stm32f407.ld -mcpu=cortex-m4 -mthumb -Wl,--gc-sections")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(PROJECT_ROOT "${CMAKE_SOURCE_DIR}/..")

include_directories(
    "${PROJECT_ROOT}/ChibiOS"
    "${PROJECT_ROOT}/ChibiOS/os/rt/include"
    "${PROJECT_ROOT}/ChibiOS/os/rt/include/arch/ARMCMx"
    "${PROJECT_ROOT}/ChibiOS/os/hal/include"
    "${PROJECT_ROOT}/ChibiOS/os/license"
    "${PROJECT_ROOT}/ChibiOS/os/common/portability/GCC"
    "${PROJECT_ROOT}/ChibiOS/os/hal/osal/rt-nil"
    "${PROJECT_ROOT}/ChibiOS/os/various/cpp_wrappers"
)

message(STATUS "[SUCCESS] toolchain.cmake rewritten with full minimal ChibiOS config ✅")
