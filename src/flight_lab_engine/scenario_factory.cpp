#include "scenario_factory.h"

#include "virtual_pilot/pitch_step_scenario.h"

std::unique_ptr<Scenario> ScenarioFactory::create(ScenarioType type, std::string &error)
{
    switch (type) {
    case ScenarioType::PitchStep:
        return std::make_unique<PitchStepScenario>();
    }

    error = "Unsupported scenario type";
    return {};
}
