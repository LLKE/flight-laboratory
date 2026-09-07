#include "pid_control_loop.h"



void pidControlLoop::update(double dt) {
    const float setpoint = _step_pilot.generate_setpoint();
    const float measurement = _model.getPrevValue();
    const float control_command = getControlCommand(setpoint, measurement, dt);
    const float pitch_value = _model.getValue(control_command, dt);
}