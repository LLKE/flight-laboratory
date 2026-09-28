#ifndef PID_CONTROL_LOOP_H
#define PID_CONTROL_LOOP_H

#include "virtual_pilot/pitch_step_pilot.h"
#include "control/loops/control_loop.h"
#include "control/controllers/pid.h"
#include "models/pitch_model.h"

// Generates an output that can be displayed in front end.
class pidControlLoop : public ControlLoop {

public:
    pidControlLoop();
    
    float update(double dt) override;
    float getSetpoint() override;

private:

    PitchStepPilot _step_pilot {};
    PIDController _pid_controller {{}, 1.5, 0.05, 0.4};
    PitchModel _model {0.45, 0.5};
};

#endif