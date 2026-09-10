#include "pid_control_loop.h"



void pidControlLoop::update(float dt) {
    const float setpoint = _step_pilot.generate_setpoint(dt);
    const float measurement = _model.getPrevValue();
    const float control_command = _pid_controller.getControlCommand(setpoint, measurement, dt);
    const float pitch_value = _model.getValue(control_command, dt);
}