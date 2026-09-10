#include "pitch_step_pilot.h"


PitchStepPilot::PitchStepPilot() :
_delay(0), _magnitude(1)
{}

PitchStepPilot::PitchStepPilot(float delay, float magnitude) :
_delay(delay), _magnitude(magnitude)
{}

float PitchStepPilot::generate_setpoint(double dt) {
    _current_time += dt;
    return (_current_time >= _delay) ? _magnitude : 0.0;
}