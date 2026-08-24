#ifndef PID_H
#define PID_H
#include <vector>

class pid
{
public:
    pid(std::vector<float> actuator_constraints, float p, float i, float d);

    float getControlCommand(const float error, const float dt) {calcControlCommand(error, dt); return _control_command;};

private:
    void calcControlCommand(const float error, const float dt);

    const float _p;
    const float _i;
    const float _d;

    const std::vector<float> _actuator_constraints {};

    float _control_command {};
    float _error_prev {};

};

#endif // PID_H
