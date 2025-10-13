#pragma once
#include <cstdint>
#include <iostream>

template<typename T, int SIZE>
class Queue {
private:
    T buffer[SIZE];
    int head = 0;
    int tail = 0;
    int count = 0;

public:
    bool push(const T& val) {
        if (count >= SIZE) { std::cout << "Queue full at: " << val << "\n"; return false; }
        buffer[tail] = val;
        tail = (tail + 1) % SIZE;
        count++;
        return true;
    }
    bool pop(T& val) {
        if (count == 0) return false;
        val = buffer[head];
        head = (head + 1) % SIZE;
        count--;
        return true;
    }
};
