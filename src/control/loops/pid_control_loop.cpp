#include "pid_control_loop.h"
#include <iostream>

pidControlLoop::pidControlLoop(){}

float pidControlLoop::update(float setpoint, double dt) {
    const float measurement = _model.getPrevValue();
    const float control_command = _pid_controller.getControlCommand(setpoint, measurement, dt);
    const float pitch_value = _model.getValue(control_command, dt);

    return pitch_value;
}

void pidControlLoop::updateControllerParams(const ControllerParams& params) {
    _pid_controller.setControlParams(params.kp, params.ki, params.kd);
}

void pidControlLoop::updateModelParams()
{}