#include "pid.h"

pid::pid(std::vector<float> actuator_constraints, float p, float i, float d)
    : _actuator_constraints(actuator_constraints), _p(p), _i(i), _d(d)
{}

float pid::calcControlCommand(const float setpoint, const float measurement, const float dt) {
    const float error = setpoint - measurement;
    _integral += error * dt;

    float output = _p * error + _i * _integral + _d * (error - _error_prev) / dt;
    _error_prev = error;
    return output;
}
