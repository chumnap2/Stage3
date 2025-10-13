cmake_minimum_required(VERSION 3.20)
project(Stage3_test C CXX)

# OS layer directory
set(CHIBIOS_OS_DIR ${CMAKE_SOURCE_DIR}/../Os/ChibiOs)

# Source files
set(OS_SOURCES
    ${CHIBIOS_OS_DIR}/Semaphore.cpp
    ${CHIBIOS_OS_DIR}/Queue.cpp
    ${CHIBIOS_OS_DIR}/Time.cpp
    ${CHIBIOS_OS_DIR}/Task.cpp
)

set(COMPONENT_SOURCES
    components/SampleComponent.cpp
)

add_executable(Stage3_test main.cpp ${OS_SOURCES} ${COMPONENT_SOURCES})

# Compile options
target_compile_options(Stage3_test PRIVATE -Wall -Wextra -std=c++17)
