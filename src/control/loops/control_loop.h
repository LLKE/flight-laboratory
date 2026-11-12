#ifndef CONTROL_LOOP_H
#define CONTROL_LOOP_H

#include "../param_sets.h"
#include "virtual_pilot/pitch_step_pilot.h"

#include <variant>

using ControllerParams = std::variant<PIDParams>;
using VirtualPilotType = std::variant<PitchStepPilot>;

class ControlLoop {

public:
    ControlLoop() {};  

    virtual float update(double dt) = 0;
    virtual float getSetpoint() = 0;
    virtual VirtualPilotType& getVirtualPilot() = 0;

    virtual void updateControllerParams(const ControllerParams& params) = 0;
    virtual void updateModelParams() = 0;
};

#endif // CONTROL_LOOP_H