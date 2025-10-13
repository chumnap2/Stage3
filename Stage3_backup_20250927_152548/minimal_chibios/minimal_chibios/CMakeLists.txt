cmake_minimum_required(VERSION 3.20)
project(minimal_chibios C CXX ASM)

set(CHIBIOS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/chibios")

add_subdirectory(${CHIBIOS_DIR}/os ${CMAKE_CURRENT_BINARY_DIR}/chibios_build)

add_executable(${PROJECT_NAME} src/main.cpp)

target_include_directories(${PROJECT_NAME} PRIVATE
    src
    ${CHIBIOS_DIR}/os/include
    ${CHIBIOS_DIR}/os/hal/ports/STM32/STM32F4xx/Include
)

target_link_libraries(${PROJECT_NAME} ch)
