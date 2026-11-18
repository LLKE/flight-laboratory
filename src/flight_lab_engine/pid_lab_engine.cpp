#include "pid_lab_engine.h"

#include <cmath>
#include <stdexcept>
#include <utility>

#include "control/loops/pid_control_loop.h"

namespace
{
std::unique_ptr<ControlLoop> createControlLoop(ControlLoopType type, std::string &error)
{
    switch (type) {
    case ControlLoopType::Pid:
        return std::make_unique<pidControlLoop>();
    }

    error = "Unsupported control loop type";
    return {};
}
}

PidLabEngine::PidLabEngine()
{
    std::string error;
    _control_loop = createControlLoop(_controlLoopType, error);
    if (!_control_loop || !_control_loop->updateControllerParams(_controller_params, error)
        || !_control_loop->updateModelParams(_model_params, error)) {
        throw std::runtime_error(error);
    }

    _scenario = ScenarioFactory::create(_scenarioType, error);
    if (!_scenario) {
        throw std::runtime_error(error);
    }
}

PidLabState PidLabEngine::state() const
{
    return {
        _response,
        _setpoint,
        _control_effort,
        _accumulated_control_effort,
        _response_metrics.overshoot(),
        _response_metrics.settlingTime(),
        _response_metrics.steadyStateError(),
        _metrics_changed
    };
}

bool PidLabEngine::setControlLoopType(ControlLoopType type, std::string &error)
{
    if (_controlLoopType == type) {
        return true;
    }

    auto controlLoop = createControlLoop(type, error);
    if (!controlLoop || !controlLoop->updateControllerParams(_controller_params, error)
        || !controlLoop->updateModelParams(_model_params, error)) {
        return false;
    }

    _control_loop = std::move(controlLoop);
    _controlLoopType = type;
    return true;
}

bool PidLabEngine::setScenarioType(ScenarioType type, std::string &error)
{
    if (_scenarioType == type) {
        return true;
    }

    auto scenario = ScenarioFactory::create(type, error);
    if (!scenario) {
        return false;
    }

    _scenario = std::move(scenario);
    _scenarioType = type;
    reset();
    return true;
}

bool PidLabEngine::setControllerParams(const ControlLoopParams &params, std::string &error)
{
    if (!_control_loop) {
        error = "No control loop is configured";
        return false;
    }
    if (!_control_loop->updateControllerParams(params, error)) {
        return false;
    }

    _controller_params = params;
    return true;
}

bool PidLabEngine::setModelParams(const ControlModelParams &params, std::string &error)
{
    if (!_control_loop) {
        error = "No control loop is configured";
        return false;
    }
    if (!_control_loop->updateModelParams(params, error)) {
        return false;
    }

    _model_params = params;
    return true;
}

bool PidLabEngine::configureScenario(const ScenarioParams &configuration, std::string &error)
{
    if (!_scenario) {
        error = "No scenario is configured";
        return false;
    }

    return _scenario->configure(configuration, error);
}

void PidLabEngine::step(double dt)
{
    if (!_control_loop || !_scenario) {
        return;
    }

    const ScenarioSample sample = _scenario->advance(dt);
    _setpoint = sample.reference;
    _response = _control_loop->update(_setpoint, dt);
    const double controlEffort = _control_loop->controlCommand();
    _control_effort = controlEffort;
    _accumulated_control_effort += std::abs(controlEffort) * dt;
    _metrics_changed = _response_metrics.observe(sample.referenceChange, _response, dt);
}

void PidLabEngine::reset()
{
    if (_control_loop) {
        _control_loop->reset();
    }
    if (_scenario) {
        _scenario->reset();
    }

    _response = 0.0;
    _setpoint = 0.0;
    _control_effort = 0.0;
    _accumulated_control_effort = 0.0;
    _response_metrics.reset();
    _metrics_changed = true;
}