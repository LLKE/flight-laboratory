#ifndef CONTROL_LOOP_H
#define CONTROL_LOOP_H


class ControlLoop {

public:
    ControlLoop() {};  

    virtual float update(double dt) = 0;
};

#endif // CONTROL_LOOP_H