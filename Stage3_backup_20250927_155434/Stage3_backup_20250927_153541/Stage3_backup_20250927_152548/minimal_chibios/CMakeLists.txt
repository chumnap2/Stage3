cmake_minimum_required(VERSION 3.15)
project(minimal_chibios C CXX ASM)

# Sources (only your main.cpp + stubs/headers in src/)
set(SOURCES
    src/main.cpp
)

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

# Compiler flags
target_compile_options(${PROJECT_NAME}.elf PRIVATE
    -mcpu=cortex-m4
    -mthumb
    -O2
    -ffunction-sections
    -fdata-sections
    -Wall
    -Wextra
)
