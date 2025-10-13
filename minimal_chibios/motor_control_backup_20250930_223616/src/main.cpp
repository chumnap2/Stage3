/*
Author: Chumnap Thach
Date: 2025-09-30 22:36:16
Description: Motor control project file
*/

#include "motor.h"
#include "config.h"
#include <csignal>
#include <unistd.h>
#include <fstream>
#include <iostream>
#include <string>

Motor* motorPtr = nullptr;

void signalHandler(int signum){
    if(motorPtr) motorPtr->stop();
    std::cout << "\nStopping motor...\n";
}

int main(int argc, char* argv[]){
    std::signal(SIGINT, signalHandler);
    MotorConfig cfg = readConfig("motor.cfg");

    // Daemonize if requested
    if(argc > 1 && std::string(argv[1]) == "--daemon"){
        if(fork() > 0) return 0;  // parent exits
        setsid();                  // create new session

        // Write PID BEFORE closing stdout/stderr
        std::ofstream pidFile("../motor.pid");
        pidFile << getpid() << std::endl;
        pidFile.close();

        fclose(stdin);
        fclose(stdout);
        fclose(stderr);
    }

    Motor motor(cfg);
    motorPtr = &motor;
    motor.run();
    return 0;
}
