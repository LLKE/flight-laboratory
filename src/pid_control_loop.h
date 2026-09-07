#ifndef PID_CONTROL_LOOP_H
#define PID_CONTROL_LOOP_H

#include "virtual_pilot/pitch_step_pilot.h"
#include "pid.h"
#include "pitchmodel.h"

// Generates an output that can be displayed in front end.
class pidControlLoop {

public:
    void update(double dt);

private:

    PitchStepPilot _step_pilot {};
    PIDController _pid_controller;
    PitchModel _model;

};

#endif