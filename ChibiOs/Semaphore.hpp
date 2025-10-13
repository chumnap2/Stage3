#pragma once
#include <cstdint>

class Semaphore {
private:
    int count;
public:
    Semaphore(int init = 0) : count(init) {}
    void signal() { count++; }
    bool wait(int timeout_ms = 0) { 
        if (count > 0) { count--; return true; } 
        return false; 
    }
};
