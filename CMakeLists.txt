cmake_minimum_required(VERSION 3.20)
project(Stage3_test CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# STM32 toolchain
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/stm32f4_toolchain.cmake")

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/components
    ${CMAKE_CURRENT_SOURCE_DIR}/Os/ChibiOs
)

# Source files
set(SRC_FILES
    main.cpp
    components/SampleComponent.cpp
    Os/ChibiOs/Queue.cpp
    Os/ChibiOs/Semaphore.cpp
    Os/ChibiOs/Task.cpp
    Os/ChibiOs/Time.cpp
)

# Build executable
add_executable(Stage3_test ${SRC_FILES})
