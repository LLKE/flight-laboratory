#ifndef PID_H
#define PID_H
#include <vector>

class pid
{
public:
    pid(std::vector<float> actuator_constraints, float p, float i, float d);

    float getControlCommand(const float setpoint, const float actual, const float dt)
        { calcControlCommand(setpoint, actual, dt); return _control_command; };

private:
    float calcControlCommand(const float setpoint, const float measurement, const float dt);

    const float _p;
    const float _i;
    const float _d;

    const std::vector<float> _actuator_constraints {};

    float _control_command {};
    float _error_prev {};
    float _integral {};

};

#endif // PID_H
