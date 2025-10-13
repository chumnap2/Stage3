// Author: chumnap thach
// Date: 2025-09-24
// Description: Task interface for Stage3 F' integration

#pragma once
#include <functional>

class Task {
public:
    void start(std::function<void()> func);
};
