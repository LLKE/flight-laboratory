#ifndef PITCH_STEP_SCENARIO_H
#define PITCH_STEP_SCENARIO_H

#include "pitch_step_pilot.h"

class PitchStepScenario
{
public:
    float advance(double dt);
    void setSetpointMagnitude(float magnitude);
    void reset();

private:
    PitchStepPilot _pilot;
};

#endif // PITCH_STEP_SCENARIO_H
