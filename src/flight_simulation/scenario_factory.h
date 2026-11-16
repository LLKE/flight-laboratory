#ifndef SCENARIO_FACTORY_H
#define SCENARIO_FACTORY_H

#include <memory>

#include <QString>

#include "scenario.h"

class ScenarioFactory
{
public:
    static std::unique_ptr<Scenario> create(const QString &type, QString &error);
};

#endif // SCENARIO_FACTORY_H
