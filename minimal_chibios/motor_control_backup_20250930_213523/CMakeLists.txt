cmake_minimum_required(VERSION 3.10)
project(motor_control)
set(CMAKE_CXX_STANDARD 17)
include_directories(include)
add_executable(motor_control
    src/main.cpp
    src/motor.cpp
    src/config.cpp
)
