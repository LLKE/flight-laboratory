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

bool PitchStepScenario::configure(const QVariantMap &configuration, QString &error)
{
    for (auto it = configuration.cbegin(); it != configuration.cend(); ++it) {
        if (it.key() != QStringLiteral("magnitude")) {
            error = QStringLiteral("Unsupported pitch-step scenario setting: %1").arg(it.key());
            return false;
        }

        bool ok = false;
        const double magnitude = it.value().toDouble(&ok);
        if (!ok || !std::isfinite(magnitude)
            || std::abs(magnitude) > std::numeric_limits<float>::max()) {
            error = QStringLiteral("Scenario magnitude must be a finite float");
            return false;
        }

        _pilot.setSetpointMagnitude(static_cast<float>(magnitude));
    }

    return true;
}
