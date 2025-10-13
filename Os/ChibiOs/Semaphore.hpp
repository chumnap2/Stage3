// Author: chumnap thach
// Date: 2025-09-24
// Description: Semaphore interface for Stage3 F' integration

#pragma once
#include <mutex>
#include <condition_variable>
#include <chrono>

class Semaphore {
private:
    int count;
    std::mutex mtx;
    std::condition_variable cv;

public:
    Semaphore(int init = 0) : count(init) {}

    void signal();
    bool wait(int timeout_ms = -1);
};
