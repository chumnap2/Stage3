/*
 * Author      : Chumnap Thach
 * Date        : 2025-09-30
 * Description : This project simulates a ramped VESC motor controller:
- create project directories
- generate stub files (led, uart, thread, main)
- prepend author/date/program description headers automatically
- generate CMakeLists.txt
- build and run ramp simulation (Ctrl+C triggers smooth ramp-down)
 * File        : led.hpp
 */
#pragma once
#include <iostream>
#include <string>

class LED {
    std::string name;
    bool state;
public:
    LED(const std::string& n = "LED") : name(n), state(false) {}
    static void init() { std::cout << "[LED] init\n"; }
    void on()  { state = true;  std::cout << "[LED] " << name << " ON\n"; }
    void off() { state = false; std::cout << "[LED] " << name << " OFF\n"; }
};
