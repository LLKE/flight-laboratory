#include "pitch_step_scenario.h"

#include <cmath>
#include <limits>

ScenarioSample PitchStepScenario::advance(double dt)
{
    const double reference = _pilot.generateSetpoint(dt);
    ScenarioSample sample {reference, std::nullopt};

    if (reference != _previousReference) {
        sample.referenceChange = ReferenceChange {_previousReference, reference};
        _previousReference = reference;
    }

    return sample;
}

void PitchStepScenario::reset()
{
    _pilot.reset();
    _previousReference = 0.0;
}

bool PitchStepScenario::configure(const ScenarioParams &configuration, std::string &error)
{
    const auto magnitudeSetting = configuration.find("magnitude");
    for (const auto &[name, value] : configuration) {
        (void)value;
        if (name != "magnitude") {
            error = "Unsupported pitch-step scenario setting: " + name;
            return false;
        }
    }

    if (magnitudeSetting != configuration.end()) {
        const double magnitude = magnitudeSetting->second;
        if (!std::isfinite(magnitude) || std::abs(magnitude) > std::numeric_limits<float>::max()) {
            error = "Scenario magnitude must be a finite float";
            return false;
        }

        _pilot.setSetpointMagnitude(static_cast<float>(magnitude));
    }

    return true;
}
