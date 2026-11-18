#include "pitch_step_pilot.h"


PitchStepPilot::PitchStepPilot() :
_delay(0), _magnitude(30)
{}

PitchStepPilot::PitchStepPilot(float delay, float magnitude) :
_delay(delay), _magnitude(magnitude)
{
    std::cout << "Reinstantiated pitch step pilot with magnitude member: " << _magnitude << "\n";    
}

float PitchStepPilot::generateSetpoint(double dt) {
    _current_time += dt;
    _setpoint = (_current_time >= _delay) ? _magnitude : 0.0;
    // std::cout << "Current setpoint: " << _setpoint << "\n";
    // std::cout << "Current time: " << _current_time << "\n";
    // std::cout << "Current delay: " << _delay << "\n";
    return _setpoint;
}

void PitchStepPilot::setSetpointMagnitude(float magnitude)
{
    _magnitude = magnitude;
}

void PitchStepPilot::reset()
{
    _current_time = 0.0f;
    _setpoint = 0.0f;
}