#include "flight_simulation/flight_simulation.h"

#include <cmath>
#include <utility>

#include "control/loops/pid_control_loop.h"
#include "scenario_factory.h"

FlightLabAdapter::FlightSimulation(QObject *parent)
    : QObject(parent)
{
    _simulation_timer.setInterval(_dt * 1000);
    connect(&_simulation_timer, &QTimer::timeout, this, &FlightLabAdapter::update);
    makeControlLoop(_controlLoopType);
    QString error;
    _scenario = ScenarioFactory::create(_scenario_type, error);
    _response_metrics.reset();
    _simulation_timer.start();
}

void FlightLabAdapter::setDt(double dt)
{
    if (_dt == dt) {
        return;
    }

    _dt = dt;
    _simulation_timer.setInterval(_dt * 1000);
    emit dtChanged(_dt);
}

void FlightLabAdapter::setControlLoopType(const QString &type)
{
    if (_controlLoopType == type) {
        return;
    }

    _controlLoopType = type;
    makeControlLoop(type);
    emit controlLoopTypeChanged();
}

void FlightLabAdapter::setScenarioType(const QString &type)
{
    if (_scenario_type == type) {
        return;
    }

    QString error;
    auto scenario = ScenarioFactory::create(type, error);
    if (!scenario) {
        emit scenarioConfigurationError(error);
        return;
    }

    _scenario = std::move(scenario);
    _scenario_type = type;
    emit scenarioTypeChanged();
    restartSim();
}

void FlightLabAdapter::makeControlLoop(const QString &type)
{
    Q_UNUSED(type);
    _control_loop = std::make_unique<pidControlLoop>();
    QString error;
    if (!_control_loop->updateControllerParams(_controller_params, error)) {
        emit controllerConfigurationError(error);
    }
}

void FlightLabAdapter::update()
{
    if (_control_loop && _scenario) {
        const ScenarioSample sample = _scenario->advance(_dt);
        _setpoint = sample.reference;
        _response = _control_loop->update(_setpoint, _dt);
        const double controlEffort = _control_loop->controlCommand();
        if (controlEffort != _control_effort) {
            _control_effort = controlEffort;
            emit controlEffortChanged(_control_effort);
        }
        _accumulated_control_effort += std::abs(controlEffort) * _dt;
        emit accumulatedControlEffortChanged(_accumulated_control_effort);
        if (_response_metrics.observe(sample.referenceChange, _response, _dt)) {
            emit overshootChanged(_response_metrics.overshoot());
            emit settlingTimeChanged(_response_metrics.settlingTime());
            emit steadyStateErrorChanged(_response_metrics.steadyStateError());
        }
        emit responseChanged(_response);
        emit setpointChanged(_setpoint);
    }
}

bool FlightLabAdapter::setControllerParams(const QVariantMap &params)
{
    if (!_control_loop) {
        const QString error = QStringLiteral("No control loop is configured");
        emit controllerConfigurationError(error);
        return false;
    }

    QString error;
    if (!_control_loop->updateControllerParams(params, error)) {
        emit controllerConfigurationError(error);
        return false;
    }

    _controller_params = params;
    return true;
}

bool FlightLabAdapter::configureScenario(const QVariantMap &configuration)
{
    if (!_scenario) {
        emit scenarioConfigurationError(QStringLiteral("No scenario is configured"));
        return false;
    }

    QString error;
    if (!_scenario->configure(configuration, error)) {
        emit scenarioConfigurationError(error);
        return false;
    }

    return true;
}

void FlightLabAdapter::restartSim()
{
    _simulation_timer.stop();
    makeControlLoop(_controlLoopType);
    if (_scenario) {
        _scenario->reset();
    }
    _response = 0.0f;
    _setpoint = 0.0;
    _control_effort = 0.0;
    _accumulated_control_effort = 0.0;
    _response_metrics.reset();
    emit responseChanged(_response);
    emit setpointChanged(_setpoint);
    emit overshootChanged(_response_metrics.overshoot());
    emit settlingTimeChanged(_response_metrics.settlingTime());
    emit steadyStateErrorChanged(_response_metrics.steadyStateError());
    emit controlEffortChanged(_control_effort);
    emit accumulatedControlEffortChanged(_accumulated_control_effort);
    _simulation_timer.start();
}