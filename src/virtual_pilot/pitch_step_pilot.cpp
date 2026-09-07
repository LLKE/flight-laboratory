#include "pitch_step_pilot.h"


PitchStepPilot::PitchStepPilot() :
_delay(0)
{}

PitchStepPilot::PitchStepPilot(float delay) :
_delay(delay) 
{}

float PitchStepPilot::generate_setpoint() {
    return _step_timer.isElapsed(_delay) ? 1 : 0;
}