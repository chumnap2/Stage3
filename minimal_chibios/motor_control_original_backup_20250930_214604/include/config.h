#pragma once
#include <string>

struct MotorConfig {
    int max_rpm = 5000;
    int step = 50;
    int delay_ms = 100;
    std::string log_file = "./motor.log";
};

MotorConfig readConfig(const std::string &filename);
