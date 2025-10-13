#pragma once
#include <iostream>
#include <functional>

class Task {
private:
    std::function<void()> fn;
public:
    Task(std::function<void()> f) : fn(f) {}
    void start() { fn(); }
    void run() { fn(); }
    void join() {} // dummy for STM32
};
