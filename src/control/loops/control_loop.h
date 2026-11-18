#ifndef CONTROL_LOOP_H
#define CONTROL_LOOP_H

#include <map>
#include <string>

using ControlLoopParams = std::map<std::string, double>;

enum class ControlLoopType
{
    Pid
};

class ControlLoop {

public:
    virtual ~ControlLoop() = default;

    virtual float update(float setpoint, double dt) = 0;
    virtual float controlCommand() const { return 0.0f; }

    virtual bool updateControllerParams(const ControlLoopParams &params, std::string &error) = 0;
    virtual void updateModelParams() = 0;
    virtual void reset() = 0;
};

#endif // CONTROL_LOOP_H