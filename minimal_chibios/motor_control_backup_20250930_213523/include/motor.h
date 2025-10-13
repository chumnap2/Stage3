/*
Author: Chumnap Thach
Date: 2025-09-30
Description: Motor control minimal ChibiOS project
File: motor.h
*/

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
