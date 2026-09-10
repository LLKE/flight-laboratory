#ifndef PITCHSTEPPILOT_H
#define PITCHSTEPPILOT_H

#include "util/timer.h"

#include "virtual_pilot.h"

class PitchStepPilot : public VirtualPilot
{
public:
    PitchStepPilot();
    PitchStepPilot(float delay, float magnitude); 
    float generate_setpoint(double dt) override;

private: 

private: 
    float _magnitude {};
    float _delay {};
    float _current_time {};

};

#endif // PITCHSTEPPILOT_H