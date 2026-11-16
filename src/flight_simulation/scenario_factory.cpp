#include "scenario_factory.h"

#include "virtual_pilot/pitch_step_scenario.h"

std::unique_ptr<Scenario> ScenarioFactory::create(const QString &type, QString &error)
{
    if (type == QStringLiteral("pitch-step")) {
        return std::make_unique<PitchStepScenario>();
    }

    error = QStringLiteral("Unknown scenario type: %1").arg(type);
    return {};
}
