#include "pid.h"

pid::pid(std::vector<float> actuator_constraints, float p, float i, float d)
    : _actuator_constraints(actuator_constraints), _p(p), _i(i), _d(d)
{}

pid::calcControlCommand(const float error, const float dt) {
    return _p * error + _i * (error - _error_prev) + _d * (error - _error_prev) / dt;
}
