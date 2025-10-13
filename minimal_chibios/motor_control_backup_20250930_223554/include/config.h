/*
Author: Chumnap Thach
Date: 2025-09-30 22:35:54
Description: Motor control project file
*/

/*
Author: Chumnap Thach
Date: 2025-09-30
Description: Motor control minimal ChibiOS project
File: config.h
*/

#pragma once
#include <string>

struct MotorConfig {
    int max_rpm = 5000;
    int step = 50;
    int delay_ms = 100;
    std::string log_file = "./motor.log";
};

MotorConfig readConfig(const std::string &filename);
