#include "pid_lab_adapter.h"

#include <map>
#include <string>

namespace
{
bool convertParameters(const QVariantMap &input, std::map<std::string, double> &output,
                       QString &error)
{
    output.clear();
    for (auto it = input.cbegin(); it != input.cend(); ++it) {
        bool converted = false;
        const double value = it.value().toDouble(&converted);
        if (!converted) {
            error = QStringLiteral("Parameter '%1' must be numeric").arg(it.key());
            return false;
        }
        output.emplace(it.key().toStdString(), value);
    }
    return true;
}

QString controlLoopTypeName(ControlLoopType type)
{
    switch (type) {
    case ControlLoopType::Pid:
        return QStringLiteral("pid");
    }
    return {};
}

QString scenarioTypeName(ScenarioType type)
{
    switch (type) {
    case ScenarioType::PitchStep:
        return QStringLiteral("pitch-step");
    }
    return {};
}
}

PidLabAdapter::PidLabAdapter(QObject *parent)
    : FlightLabAdapter(std::make_unique<PidLabEngine>(), parent),
      _engine(static_cast<PidLabEngine *>(&engine()))
{
    connect(this, &FlightLabAdapter::engineStepped, this, [this] {
        publishState(false);
    });
    connect(this, &FlightLabAdapter::engineReset, this, [this] {
        publishState(true);
    });
    publishState(true);
    startEngine();
}

QString PidLabAdapter::controlLoopType() const
{
    return controlLoopTypeName(_engine->controlLoopType());
}

QString PidLabAdapter::scenarioType() const
{
    return scenarioTypeName(_engine->scenarioType());
}

double PidLabAdapter::response() const { return _engine->state().response; }
double PidLabAdapter::setpoint() const { return _engine->state().setpoint; }
double PidLabAdapter::overshoot() const { return _engine->state().overshoot; }
double PidLabAdapter::settlingTime() const { return _engine->state().settlingTime; }
double PidLabAdapter::steadyStateError() const { return _engine->state().steadyStateError; }
double PidLabAdapter::controlEffort() const { return _engine->state().controlEffort; }
double PidLabAdapter::accumulatedControlEffort() const
{
    return _engine->state().accumulatedControlEffort;
}

void PidLabAdapter::setControlLoopType(const QString &type)
{
    if (type == controlLoopType()) {
        return;
    }
    if (type != QStringLiteral("pid")) {
        emit controllerConfigurationError(
            QStringLiteral("Unknown control loop type: %1").arg(type));
        return;
    }

    std::string error;
    if (!_engine->setControlLoopType(ControlLoopType::Pid, error)) {
        emit controllerConfigurationError(QString::fromStdString(error));
        return;
    }
    emit controlLoopTypeChanged();
}

void PidLabAdapter::setScenarioType(const QString &type)
{
    if (type == scenarioType()) {
        return;
    }
    if (type != QStringLiteral("pitch-step")) {
        emit scenarioConfigurationError(QStringLiteral("Unknown scenario type: %1").arg(type));
        return;
    }

    std::string error;
    if (!_engine->setScenarioType(ScenarioType::PitchStep, error)) {
        emit scenarioConfigurationError(QString::fromStdString(error));
        return;
    }
    emit scenarioTypeChanged();
    publishState(true);
}

bool PidLabAdapter::setControllerParams(const QVariantMap &params)
{
    ControlLoopParams convertedParams;
    QString conversionError;
    if (!convertParameters(params, convertedParams, conversionError)) {
        emit controllerConfigurationError(conversionError);
        return false;
    }

    std::string error;
    if (!_engine->setControllerParams(convertedParams, error)) {
        emit controllerConfigurationError(QString::fromStdString(error));
        return false;
    }
    return true;
}

bool PidLabAdapter::configureScenario(const QVariantMap &configuration)
{
    ScenarioParams convertedConfiguration;
    QString conversionError;
    if (!convertParameters(configuration, convertedConfiguration, conversionError)) {
        emit scenarioConfigurationError(conversionError);
        return false;
    }

    std::string error;
    if (!_engine->configureScenario(convertedConfiguration, error)) {
        emit scenarioConfigurationError(QString::fromStdString(error));
        return false;
    }
    return true;
}

void PidLabAdapter::publishState(bool force)
{
    const PidLabState state = _engine->state();
    const bool hasControlEffortChanged = !_hasPublishedState
        || state.controlEffort != _lastPublishedState.controlEffort;

    emit responseChanged(state.response);
    emit setpointChanged(state.setpoint);
    if (force || hasControlEffortChanged) {
        emit controlEffortChanged(state.controlEffort);
    }
    emit accumulatedControlEffortChanged(state.accumulatedControlEffort);
    if (force || state.metricsChanged) {
        emit overshootChanged(state.overshoot);
        emit settlingTimeChanged(state.settlingTime);
        emit steadyStateErrorChanged(state.steadyStateError);
    }

    _lastPublishedState = state;
    _hasPublishedState = true;
}
