#include "pitchmodel.h"

pitchModel::pitchModel(float elevator_eff, float pitch_damping, float timestep)
    : _elevator_effectiveness(elevator_eff), _pitch_damping(pitch_damping)
{}

void pitchModel::calc_value(const float elevator_deflection, const float time) {

    const float timestep = time - _timestep_prev;

    // Elevator deflection creates a pitching moment, causing pitch acceleration
    float pitch_accel = _elevator_effectiveness * elevator_deflection - _pitch_damping * _state_prev.pitch_rate;

    _state.pitch_rate = _state_prev.pitch_rate + timestep * pitch_accel;
    _state.pitch = _state_prev.pitch + _state.pitch_rate * timestep;

    _timestep_prev = timestep;
}
