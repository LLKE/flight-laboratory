#include "pitchmodel.h"

pitchModel::pitchModel(float elevator_eff, float pitch_damping, float timestep)
    : elevator_effectiveness(elevator_eff), pitch_damping(pitch_damping), timestep(timestep)
{}

void pitchModel::calc_value(const float elevator_deflection) {

    // Elevator deflection creates a pitching moment, causing pitch acceleration
    float pitch_accel = _elevator_effectiveness * elevator_deflection - _pitch_damping * _state_prev.pitch_rate;

    _state.pitch_rate = _state_prev.pitch_rate + _timestep * pitch_accel;
    _state.pitch = _state_prev.pitch + _state.pitch_rate * _timestep;
}
