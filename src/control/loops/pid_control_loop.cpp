#include "pid_control_loop.h"

#include <cmath>
#include <iostream>
#include <limits>

pidControlLoop::pidControlLoop(){}

float pidControlLoop::update(float setpoint, double dt) {
    const float measurement = _model.getPrevValue();
    const float control_command = _pid_controller.getControlCommand(setpoint, measurement, dt);
    const float pitch_value = _model.getValue(control_command, dt);

    return pitch_value;
}

bool pidControlLoop::updateControllerParams(const ControlLoopParams &params, std::string &error) {
    const char *const names[] = {"kp", "ki", "kd"};
    for (const auto &[name, value] : params) {
        (void)value;
        if (name != "kp" && name != "ki" && name != "kd") {
            error = "Unsupported PID controller parameter: " + name;
            return false;
        }
    }

    float values[3];
    int index = 0;
    for (const char *name : names) {
        const auto it = params.find(name);
        if (it == params.end()) {
            error = "Missing PID controller parameter: " + std::string(name);
            return false;
        }
        const double value = it->second;
        if (!std::isfinite(value) || std::abs(value) > std::numeric_limits<float>::max()) {
            error = "Invalid PID controller parameter: " + std::string(name);
            return false;
        }
        values[index++] = static_cast<float>(value);
    }

    _pid_controller.setControlParams(values[0], values[1], values[2]);
    return true;
}

bool pidControlLoop::updateModelParams(const ControlModelParams &params, std::string &error)
{
    for (const auto &[name, value] : params) {
        (void)value;
        if (name != "pitch_damping" && name != "elevator_effectiveness") {
            error = "Unsupported pitch model parameter: " + name;
            return false;
        }
    }

    const auto pitchDamping = params.find("pitch_damping");
    if (pitchDamping == params.end()) {
        error = "Missing pitch model parameter: pitch_damping";
        return false;
    }
    const auto elevatorEffectiveness = params.find("elevator_effectiveness");
    if (elevatorEffectiveness == params.end()) {
        error = "Missing pitch model parameter: elevator_effectiveness";
        return false;
    }

    const double damping = pitchDamping->second;
    const double effectiveness = elevatorEffectiveness->second;
    if (!std::isfinite(damping) || std::abs(damping) > std::numeric_limits<float>::max()) {
        error = "Invalid pitch model parameter: pitch_damping";
        return false;
    }
    if (!std::isfinite(effectiveness)
        || std::abs(effectiveness) > std::numeric_limits<float>::max()) {
        error = "Invalid pitch model parameter: elevator_effectiveness";
        return false;
    }

    _model.setPitchDamping(static_cast<float>(damping));
    _model.setElevatorEffectiveness(static_cast<float>(effectiveness));
    return true;
}

void pidControlLoop::reset()
{
    _pid_controller.reset();
    _model.reset();
}