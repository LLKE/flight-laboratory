#ifndef TIMER_H
#define TIMER_H

#include <chrono>

class Timer {

public:
    Timer() {
        _start_time = std::chrono::high_resolution_clock::now();
    }

    ~Timer() {}

    bool isElapsed(int num_seconds) {
        std::chrono::duration<double> elapsed_seconds = std::chrono::high_resolution_clock::now() - _start_time;
        return elapsed_seconds >= std::chrono::milliseconds(num_seconds * 1000);
    };

private: 
    std::chrono::time_point<std::chrono::high_resolution_clock> _start_time;
};

#endif // TIMER_H