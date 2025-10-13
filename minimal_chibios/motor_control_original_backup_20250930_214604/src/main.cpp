#include "motor.h"
#include "config.h"
#include <csignal>
#include <unistd.h>
#include <fstream>
#include <iostream>
#include <string>

Motor* motorPtr = nullptr;

void signalHandler(int signum) {
    if (motorPtr) motorPtr->stop();
    std::cout << "\nStopping motor...\n";
}

int main(int argc, char* argv[]) {
    std::signal(SIGINT, signalHandler);
    MotorConfig cfg = readConfig("motor.cfg");

    Motor motor(cfg);
    motorPtr = &motor;

    // Write PID if running in daemon mode
    if(argc > 1 && std::string(argv[1]) == "--daemon") {
        std::ofstream("motor.pid") << getpid();
    }

    motor.run(); // blocks until stopped
    return 0;
}
