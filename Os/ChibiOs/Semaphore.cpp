// Author: chumnap thach
// Date: 2025-09-24
// Description: Semaphore implementation for Stage3 F' integration

#include "Semaphore.hpp"

void Semaphore::signal() {
    std::unique_lock<std::mutex> lock(mtx);
    count++;
    cv.notify_one();
}

bool Semaphore::wait(int timeout_ms) {
    std::unique_lock<std::mutex> lock(mtx);
    if(timeout_ms < 0) {
        cv.wait(lock, [this](){ return count > 0; });
        count--;
        return true;
    } else {
        if(!cv.wait_for(lock, std::chrono::milliseconds(timeout_ms), [this](){ return count > 0; }))
            return false;
        count--;
        return true;
    }
}
