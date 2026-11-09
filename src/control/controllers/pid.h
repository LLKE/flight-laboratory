#ifndef PID_H
#define PID_H
#include <vector>
#include <iostream>

class PIDController
{
public:
    PIDController(std::vector<float> actuator_constraints, float p, float i, float d);

    float getControlCommand(const float setpoint, const float actual, const float dt)
        { calcControlCommand(setpoint, actual, dt); return _control_command; };

    void setControlParams(const float p, const float i, const float d);

private:
    void calcControlCommand(const float setpoint, const float measurement, const float dt);

    float _p;
    float _i;
    float _d;

    const std::vector<float> _actuator_constraints {};

    float _control_command {};
    float _error_prev {};
    float _integral {};

};

#endif // PID_H
