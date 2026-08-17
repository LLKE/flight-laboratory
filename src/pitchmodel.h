#ifndef PITCHMODEL_H
#define PITCHMODEL_H

class pitchModel
{
public:
    pitchModel();
    pitchModel(float elevator_eff, float pitch_damping, float timestep);

    double getValue() { return _state.pitch; };

private:

    void calc_value(const float elevator_deflection);

    float _pitch_damping {};
    float _elevator_effectiveness {};
    float _timestep {};

    struct State{
        float pitch;
        float pitch_rate;
    };

    State _state {};
    State _state_prev {};
};

#endif // PITCHMODEL_H
