#include "pid_control_loop.h"
#include <iostream>

pidControlLoop::pidControlLoop(){}

float pidControlLoop::update(double dt) {
    const float setpoint = _step_pilot.generateSetpoint(dt);
    const float measurement = _model.getPrevValue();
    const float control_command = _pid_controller.getControlCommand(setpoint, measurement, dt);
    const float pitch_value = _model.getValue(control_command, dt);

    return pitch_value;
}

float pidControlLoop::getSetpoint() {
    return _step_pilot.getSetpoint();
}