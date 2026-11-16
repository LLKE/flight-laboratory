#ifndef CONTROL_LOOP_H
#define CONTROL_LOOP_H

#include "../param_sets.h"

using ControllerParams = PIDParams;

class ControlLoop {

public:
    ControlLoop() {};  

    virtual float update(float setpoint, double dt) = 0;

    virtual void updateControllerParams(const ControllerParams& params) = 0;
    virtual void updateModelParams() = 0;
};

#endif // CONTROL_LOOP_H