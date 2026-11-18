#ifndef SCENARIO_FACTORY_H
#define SCENARIO_FACTORY_H

#include <memory>
#include <string>

#include "scenario.h"

class ScenarioFactory
{
public:
    static std::unique_ptr<Scenario> create(ScenarioType type, std::string &error);
};

#endif // SCENARIO_FACTORY_H
