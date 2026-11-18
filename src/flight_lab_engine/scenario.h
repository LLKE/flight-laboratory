#ifndef SCENARIO_H
#define SCENARIO_H

#include <optional>
#include <map>
#include <string>

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

using ScenarioParams = std::map<std::string, double>;

enum class ScenarioType
{
    PitchStep
};

class Scenario
{
public:
    virtual ~Scenario() = default;

    virtual ScenarioSample advance(double dt) = 0;
    virtual void reset() = 0;
    virtual bool configure(const ScenarioParams &configuration, std::string &error) = 0;
};

#endif // SCENARIO_H
