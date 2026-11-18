#ifndef PITCHMODEL_H
#define PITCHMODEL_H

class PitchModel
{
public:
    PitchModel(float elevator_eff, float pitch_damping);

    double getValue(const float elevator_deflection, const float timestep) { calc_value(elevator_deflection, timestep); return _state.pitch; };

    double getPrevValue() { return _state_prev.pitch; };
    float pitchDamping() const { return _pitch_damping; }
    float elevatorEffectiveness() const { return _elevator_effectiveness; }
    void setPitchDamping(float pitch_damping) { _pitch_damping = pitch_damping; }
    void setElevatorEffectiveness(float elevator_effectiveness)
    {
        _elevator_effectiveness = elevator_effectiveness;
    }
    void reset();

private:

    void calc_value(const float elevator_deflection, const float timestep);

    float _pitch_damping {};
    float _elevator_effectiveness {};
    float _timestep_prev {};

    struct State {
        float pitch;
        float pitch_rate;
    };

    State _state {};
    State _state_prev {};
};

#endif // PITCHMODEL_H
