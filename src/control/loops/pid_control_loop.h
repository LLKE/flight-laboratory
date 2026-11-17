#ifndef PID_CONTROL_LOOP_H
#define PID_CONTROL_LOOP_H

#include "control/loops/control_loop.h"
#include "control/controllers/pid.h"
#include "models/pitch_model.h"

// Generates an output that can be displayed in front end.
class pidControlLoop : public ControlLoop {

public:
    pidControlLoop();
    
    float update(float setpoint, double dt) override;
    float controlCommand() const override { return _pid_controller.controlCommand(); }
    bool updateControllerParams(const QVariantMap &params, QString &error) override;
    void updateModelParams() override;

private:
    PIDController _pid_controller {{}, 1.5, 0.05, 0.4};
    PitchModel _model {0.45, 0.5};
};

#endif