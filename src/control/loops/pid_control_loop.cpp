#include "pid_control_loop.h"
#include <iostream>

pidControlLoop::pidControlLoop(){}

float pidControlLoop::update(double dt) {
    
    const float setpoint = std::visit([dt](auto& pilot) {return pilot.generateSetpoint(dt); }, _virtual_pilot);
    const float measurement = _model.getPrevValue();
    const float control_command = _pid_controller.getControlCommand(setpoint, measurement, dt);
    const float pitch_value = _model.getValue(control_command, dt);

    return pitch_value;
}

float pidControlLoop::getSetpoint() {
    return std::visit([](auto& pilot) {return pilot.getSetpoint(); }, _virtual_pilot);
}

void pidControlLoop::updateControllerParams(const ControllerParams& params) {
    const auto& pid_params = std::get<PIDParams>(params);
    _pid_controller.setControlParams(pid_params.kp, pid_params.ki, pid_params.kd);
}

void pidControlLoop::updateModelParams()
{}

VirtualPilotType& pidControlLoop::getVirtualPilot()
{
    return _virtual_pilot;
}