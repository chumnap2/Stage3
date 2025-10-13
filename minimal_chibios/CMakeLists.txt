cmake_minimum_required(VERSION 3.13)
project(minimal_chibios LANGUAGES C CXX ASM)

# ---------------- Deployment Settings ------------------------
# Load F Prime deployment settings (defines FPRIME_PROJECT_ROOT, FPRIME_FRAMEWORK_PATH, etc.)
include(${CMAKE_CURRENT_LIST_DIR}/settings.cmake)
# ------------------------------------------------------------

# ---------------- Components ---------------------------------
# Add MotorComponent folder to the F Prime deployment
add_fprime_subdirectory("${CMAKE_CURRENT_LIST_DIR}/motor_control")
# ------------------------------------------------------------

# ---------------- STM32 Application -------------------------
# Sources (main + stubs)
set(SOURCES
    src/main.cpp
)

# Create executable
add_executable(${PROJECT_NAME}.elf ${SOURCES})

# Include paths
target_include_directories(${PROJECT_NAME}.elf PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/src/cfg
    ${CMAKE_SOURCE_DIR}/src/stubs
)

# Linker script
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/stm32f407.ld)
target_link_options(${PROJECT_NAME}.elf PRIVATE
    -T${LINKER_SCRIPT}
    -Wl,--gc-sections
    -static
)

# Compiler flags for Cortex-M4
target_compile_options(${PROJECT_NAME}.elf PRIVATE
    -mcpu=cortex-m4
    -mthumb
    -O2
    -ffunction-sections
    -fdata-sections
    -Wall
    -Wextra
)

# ---------------- End of CMakeLists.txt ----------------------
