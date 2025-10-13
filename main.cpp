#include "Os.hpp"
#include "SampleComponent.hpp"
#include <iostream>

int main() {
    std::cout << "=== Stage 3 F' Component Integration Test ===\n";

    Queue<int, 4> q;
    for(int i=1;i<=5;i++)
        std::cout << (q.push(i) ? "Pushed: " : "Queue full at: ") << i << "\n";

    Semaphore sem;
    sem.signal();
    sem.wait(); // no argument version
    std::cout << "Semaphore acquired!\n";

    std::cout << "Current time: " << Time::now_ms() << " ms\n";

    Task task([](){ std::cout << "Task running\n"; });
    task.start();
    task.join();

    SampleComponent comp;
    comp.run();

    std::cout << "=== Stage 3 Test Complete ===\n";
    return 0;
}
