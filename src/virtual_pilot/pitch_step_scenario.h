#ifndef PITCH_STEP_SCENARIO_H
#define PITCH_STEP_SCENARIO_H

#include "flight_simulation/scenario.h"
#include "pitch_step_pilot.h"

class PitchStepScenario : public Scenario
{
public:
    ScenarioSample advance(double dt) override;
    void reset() override;
    bool configure(const QVariantMap &configuration, QString &error) override;

private:
    PitchStepPilot _pilot;
    double _previousReference {};
};

#endif // PITCH_STEP_SCENARIO_H
