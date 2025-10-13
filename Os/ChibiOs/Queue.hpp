// Author: chumnap thach
// Date: 2025-09-24
// Description: Queue interface for Stage3 F' integration

#pragma once
#include <optional>
#include <array>

template<typename T, int N>
class Queue {
private:
    std::array<T, N> buffer;
    int head = 0;
    int tail = 0;
    int count = 0;

public:
    bool push(const T& val);
    std::optional<T> pop();
};
