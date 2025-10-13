// Author: chumnap thach
// Date: 2025-09-24
// Description: Queue implementation for Stage3 F' integration

#include "Queue.hpp"

template<typename T, int N>
bool Queue<T,N>::push(const T& val) {
    if(count >= N) return false;
    buffer[tail] = val;
    tail = (tail + 1) % N;
    count++;
    return true;
}

template<typename T, int N>
std::optional<T> Queue<T,N>::pop() {
    if(count <= 0) return std::nullopt;
    T val = buffer[head];
    head = (head + 1) % N;
    count--;
    return val;
}

// Explicit instantiation example (adjust as needed)
template class Queue<int, 5>;
