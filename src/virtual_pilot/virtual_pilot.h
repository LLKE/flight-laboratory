#ifndef VIRTUAL_PILOT_H
#define VIRTUAL_PILOT_H

class VirtualPilot
{
public:
    VirtualPilot();

protected:
    float setpoint {};

    virtual float generate_setpoint() = 0;
};

#endif // VIRTUAL_PILOT_H
