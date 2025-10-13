/*
 * Author      : Chumnap Thach
 * Date        : 2025-09-30
 * Description : This project simulates a ramped VESC motor controller:
- create project directories
- generate stub files (led, uart, thread, main)
- prepend author/date/program description headers automatically
- generate CMakeLists.txt
- build and run ramp simulation (Ctrl+C triggers smooth ramp-down)
 * File        : uart.hpp
 */
#pragma once
#include <iostream>
#include <string>

class UART {
    std::string name;
public:
    UART(const std::string& n = "UART") : name(n) {}
    static void init() { std::cout << "[UART] init\n"; }
    void send(const std::string &msg) { std::cout << "[UART] " << name << " TX: " << msg << "\n"; }
    void receive(const std::string &msg) { std::cout << "[UART] " << name << " RX: " << msg << "\n"; }
};
