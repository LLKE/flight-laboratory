#ifndef SCENARIO_H
#define SCENARIO_H

#include <optional>

#include <QString>
#include <QVariantMap>

struct ReferenceChange
{
    double from {};
    double to {};
};

struct ScenarioSample
{
    double reference {};
    std::optional<ReferenceChange> referenceChange;
};

class Scenario
{
public:
    virtual ~Scenario() = default;

    virtual ScenarioSample advance(double dt) = 0;
    virtual void reset() = 0;
    virtual bool configure(const QVariantMap &configuration, QString &error) = 0;
};

#endif // SCENARIO_H
