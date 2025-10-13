// Author: chumnap thach
// Date: 2025-09-24
// Description: Task implementation for Stage3 F' integration

#include "Task.hpp"

void Task::start(std::function<void()> func) {
    func();
}
