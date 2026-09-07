#ifndef PITCHSTEPPILOT_H
#define PITCHSTEPPILOT_H

#include "util/timer.h"

#include "virtual_pilot.h"

class PitchStepPilot : public VirtualPilot
{
public:
    PitchStepPilot();
    PitchStepPilot(float delay); 
    float generate_setpoint() override;

private: 

private: 
    float _delay {};

    Timer _step_timer {};
};

#endif // PITCHSTEPPILOT_H