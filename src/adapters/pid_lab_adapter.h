#ifndef PID_LAB_ADAPTER_H
#define PID_LAB_ADAPTER_H

#include <QVariantMap>

#include <QtQml/qqmlregistration.h>

#include "adapters/flight_lab_adapter.h"
#include "flight_lab_engine/pid_lab_engine.h"

class PidLabAdapter : public FlightLabAdapter
{
    Q_OBJECT
    Q_PROPERTY(QString controlLoopType READ controlLoopType WRITE setControlLoopType
               NOTIFY controlLoopTypeChanged)
    Q_PROPERTY(QString scenarioType READ scenarioType WRITE setScenarioType
               NOTIFY scenarioTypeChanged)
    Q_PROPERTY(double pitchDamping READ pitchDamping NOTIFY modelParamsChanged)
    Q_PROPERTY(double elevatorEffectiveness READ elevatorEffectiveness NOTIFY modelParamsChanged)
    Q_PROPERTY(double response READ response NOTIFY responseChanged)
    Q_PROPERTY(double setpoint READ setpoint NOTIFY setpointChanged)
    Q_PROPERTY(double overshoot READ overshoot NOTIFY overshootChanged)
    Q_PROPERTY(double settlingTime READ settlingTime NOTIFY settlingTimeChanged)
    Q_PROPERTY(double steadyStateError READ steadyStateError NOTIFY steadyStateErrorChanged)
    Q_PROPERTY(double controlEffort READ controlEffort NOTIFY controlEffortChanged)
    Q_PROPERTY(double accumulatedControlEffort READ accumulatedControlEffort
               NOTIFY accumulatedControlEffortChanged)
    QML_ELEMENT

public:
    explicit PidLabAdapter(QObject *parent = nullptr);

    QString controlLoopType() const;
    QString scenarioType() const;
    double pitchDamping() const;
    double elevatorEffectiveness() const;
    double response() const;
    double setpoint() const;
    double overshoot() const;
    double settlingTime() const;
    double steadyStateError() const;
    double controlEffort() const;
    double accumulatedControlEffort() const;

    void setControlLoopType(const QString &type);
    void setScenarioType(const QString &type);

    Q_INVOKABLE bool setControllerParams(const QVariantMap &params);
    Q_INVOKABLE bool setModelParams(const QVariantMap &params);
    Q_INVOKABLE bool configureScenario(const QVariantMap &configuration);

signals:
    void controlLoopTypeChanged();
    void scenarioTypeChanged();
    void modelParamsChanged();
    void responseChanged(double response);
    void setpointChanged(double setpoint);
    void overshootChanged(double overshoot);
    void settlingTimeChanged(double settlingTime);
    void steadyStateErrorChanged(double steadyStateError);
    void controlEffortChanged(double controlEffort);
    void accumulatedControlEffortChanged(double accumulatedControlEffort);
    void controllerConfigurationError(const QString &error);
    void modelConfigurationError(const QString &error);
    void scenarioConfigurationError(const QString &error);

private:
    void publishState(bool force);

    PidLabEngine *_engine;
    PidLabState _lastPublishedState;
    bool _hasPublishedState {};
};

#endif // PID_LAB_ADAPTER_H