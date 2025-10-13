/*
Author: Chumnap Thach
Date: 2025-09-30 22:35:54
Description: Motor control project file
*/

/*
Author: Chumnap Thach
Date: 2025-09-30
Description: Motor control minimal ChibiOS project
File: motor.cpp
*/

#include "motor.h"
#include <iostream>
#include <thread>
#include <chrono>
#include <fstream>

Motor::Motor(const MotorConfig& cfg) : config(cfg) {}
void Motor::stop() { running=false; }

void Motor::rampUpDown() {
    int rpm=0;
    bool rampingUp=true;
    while(running){
        std::cout << "RPM: " << rpm << std::endl;
        std::ofstream log(config.log_file,std::ios::app);
        log << "RPM: " << rpm << std::endl;
        std::this_thread::sleep_for(std::chrono::milliseconds(config.delay_ms));
        if(rampingUp){
            rpm+=config.step;
            if(rpm>=config.max_rpm) rampingUp=false;
        }else{
            rpm-=config.step;
            if(rpm<=0) rampingUp=true;
        }
    }
}

void Motor::run(){rampUpDown();}
