#pragma once
#include "config.h"
class Motor {
public:
    Motor(const MotorConfig& cfg);
    void run();
    void stop();
private:
    MotorConfig config;
    bool running = true;
    void rampUpDown();
};
