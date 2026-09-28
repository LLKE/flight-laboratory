#ifndef VIRTUAL_PILOT_H
#define VIRTUAL_PILOT_H

class VirtualPilot
{
public:
    VirtualPilot();
    virtual float generateSetpoint(double dt) = 0;
    virtual float getSetpoint() = 0;

protected:
    float _setpoint {};

};

#endif // VIRTUAL_PILOT_H
