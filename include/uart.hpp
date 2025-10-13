#ifndef UART_HPP
#define UART_HPP

#include <iostream>
#include <string>

class UART {
public:
    UART(const std::string& name) : name(name) {}
    void send(const std::string& msg) { std::cout << "[UART] " << name << " TX: " << msg << std::endl; }
    std::string receive() {
        std::string input;
        std::cout << "[UART] " << name << " RX: ";
        std::getline(std::cin, input);
        return input;
    }

private:
    std::string name;
};

#endif // UART_HPP
