#include "pitch_step_pilot.h"


PitchStepPilot::PitchStepPilot() :
_delay(0), _magnitude(30)
{}

PitchStepPilot::PitchStepPilot(float delay, float magnitude) :
_delay(delay), _magnitude(magnitude)
{}

float PitchStepPilot::generateSetpoint(double dt) {
    _current_time += dt;
    _setpoint = (_current_time >= _delay) ? _magnitude : 0.0;
    return _setpoint;
}