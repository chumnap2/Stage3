#include <iostream>
#include "Semaphore.hpp"
#include "Queue.hpp"
#include "Time.hpp"
#include "Task.hpp"
#include "SampleComponent.hpp"

int main() {
    std::cout << "=== Stage 3 F' Component Integration Test ===\n";

    Queue<int> q(4);
    for(int i=1;i<=5;i++) {
        if(!q.push(i)) std::cout << "Queue full at: " << i << "\n";
        else std::cout << "Pushed: " << i << "\n";
    }
    int val;
    while(q.pop(val)) std::cout << "Popped: " << val << "\n";
    std::cout << "Correctly handled empty queue\n\n";

    Semaphore sem;
    sem.signal();
    sem.wait();
    std::cout << "Semaphore acquired!\n\n";

    Time t;
    std::cout << "Current time: " << t.now_ms() << " ms\n\n";

    Task task([](){ std::cout << "Task running\n"; });
    task.run();

    SampleComponent comp;
    comp.run();

    std::cout << "=== Stage 3 Test Complete ===\n";
    return 0;
}
