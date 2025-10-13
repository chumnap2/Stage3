#ifndef LED_HPP
#define LED_HPP

#include <iostream>
#include <string>

class LED {
public:
    LED(const std::string& name) : name(name), state(false) {}
    void on() { state = true; std::cout << "[LED] " << name << " ON" << std::endl; }
    void off() { state = false; std::cout << "[LED] " << name << " OFF" << std::endl; }
    void toggle() { state = !state; std::cout << "[LED] " << name << (state ? " ON" : " OFF") << std::endl; }

private:
    std::string name;
    bool state;
};

#endif // LED_HPP
