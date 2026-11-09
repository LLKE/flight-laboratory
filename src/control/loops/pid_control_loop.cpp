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

void pidControlLoop::updateControllerParams(const ControllerParams& params) {
    const auto& pid_params = std::get<PIDParams>(params);
    _pid_controller.setControlParams(pid_params.kp, pid_params.ki, pid_params.kd);
}

void pidControlLoop::updateModelParams()
{}