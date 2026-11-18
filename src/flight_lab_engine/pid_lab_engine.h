#ifndef PID_LAB_SIM_H
#define PID_LAB_SIM_H

#include "flight_lab_engine.h"

#include <memory>
#include <string>

#include "control/loops/control_loop.h"
#include "response_metrics.h"
#include "scenario.h"
#include "scenario_factory.h"

struct PidLabState
{
    double response {};
    double setpoint {};
    double controlEffort {};
    double accumulatedControlEffort {};
    double overshoot {};
    double settlingTime {};
    double steadyStateError {};
    bool metricsChanged {};
};

class PidLabEngine : public FlightLabEngine
{
public:
    PidLabEngine();

    void step(double dt) override;
    void reset() override;

    ControlLoopType controlLoopType() const { return _controlLoopType; }
    ScenarioType scenarioType() const { return _scenarioType; }
    PidLabState state() const;

    bool setControlLoopType(ControlLoopType type, std::string &error);
    bool setScenarioType(ScenarioType type, std::string &error);
    bool setControllerParams(const ControlLoopParams &params, std::string &error);
    bool setModelParams(const ControlModelParams &params, std::string &error);
    const ControlModelParams &modelParams() const { return _model_params; }
    bool configureScenario(const ScenarioParams &configuration, std::string &error);

private:
    std::unique_ptr<ControlLoop> _control_loop;
    std::unique_ptr<Scenario> _scenario;
    ResponseMetrics _response_metrics;
    ControlLoopParams _controller_params {
        {"kp", 1.5},
        {"ki", 0.05},
        {"kd", 0.4}
    };
    ControlModelParams _model_params {
        {"pitch_damping", 0.5},
        {"elevator_effectiveness", 0.45}
    };
    ControlLoopType _controlLoopType {ControlLoopType::Pid};
    ScenarioType _scenarioType {ScenarioType::PitchStep};
    double _response {};
    double _setpoint {};
    double _control_effort {};
    double _accumulated_control_effort {};
    bool _metrics_changed {};
};

#endif // PID_LAB_SIM_H