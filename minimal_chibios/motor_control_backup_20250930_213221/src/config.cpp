/*
Author: Chumnap Thach
Date: 2025-09-30
Description: Motor control minimal ChibiOS project
File: config.cpp
*/

#include "config.h"
#include <fstream>
#include <map>

MotorConfig readConfig(const std::string &filename) {
    MotorConfig cfg;
    std::ifstream infile(filename);
    if (!infile.is_open()) return cfg;

    std::map<std::string,std::string> kv;
    std::string line;
    while (std::getline(infile,line)) {
        auto pos = line.find('=');
        if (pos!=std::string::npos) kv[line.substr(0,pos)] = line.substr(pos+1);
    }

    if (kv.count("max_rpm")) cfg.max_rpm = std::stoi(kv["max_rpm"]);
    if (kv.count("step")) cfg.step = std::stoi(kv["step"]);
    if (kv.count("delay_ms")) cfg.delay_ms = std::stoi(kv["delay_ms"]);
    if (kv.count("log_file")) cfg.log_file = kv["log_file"];
    return cfg;
}
