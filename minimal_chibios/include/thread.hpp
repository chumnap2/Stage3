/*
 * Author      : Chumnap Thach
 * Date        : 2025-09-30
 * Description : This project simulates a ramped VESC motor controller:
- create project directories
- generate stub files (led, uart, thread, main)
- prepend author/date/program description headers automatically
- generate CMakeLists.txt
- build and run ramp simulation (Ctrl+C triggers smooth ramp-down)
 * File        : thread.hpp
 */
#pragma once
#include <thread>
#include <functional>

class Thread {
    std::thread t;
public:
    Thread(std::function<void()> func) : t(std::move(func)) {}
    ~Thread() { if (t.joinable()) t.join(); }
};
