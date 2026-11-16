#include "pitch_step_scenario.h"

float PitchStepScenario::advance(double dt)
{
    return _pilot.generateSetpoint(dt);
}

void PitchStepScenario::setSetpointMagnitude(float magnitude)
{
    _pilot.setSetpointMagnitude(magnitude);
}

void PitchStepScenario::reset()
{
    _pilot.reset();
}
