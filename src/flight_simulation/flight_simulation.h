#ifndef FLIGHT_SIMULATION_H
#define FLIGHT_SIMULATION_H

#include <memory>

#include <QObject>
#include <QTimer>
#include <QString>

#include <QtQml/qqmlregistration.h>

#include "src/control/loops/control_loop.h"
#include "response_metrics.h"
#include "scenario.h"

class FlightSimulation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double response READ response NOTIFY responseChanged)
    Q_PROPERTY(double setpoint READ setpoint NOTIFY setpointChanged)
    Q_PROPERTY(double overshoot READ overshoot NOTIFY overshootChanged)
    Q_PROPERTY(QString scenarioType READ scenarioType WRITE setScenarioType NOTIFY scenarioTypeChanged)
    Q_PROPERTY(QString controlLoopType READ controlLoopType WRITE setControlLoopType NOTIFY controlLoopTypeChanged)
    Q_PROPERTY(double dt READ dt WRITE setDt NOTIFY dtChanged)
    QML_ELEMENT

public:
    explicit FlightSimulation(QObject *parent = nullptr);

    Q_INVOKABLE bool setControllerParams(const QVariantMap &params);
    Q_INVOKABLE void restartSim();

    Q_INVOKABLE bool configureScenario(const QVariantMap &configuration);

    double response() const { return _response; }
    double dt() const { return _dt; }
    double setpoint() const { return _setpoint; }
    double overshoot() const { return _response_metrics.overshoot(); }
    QString scenarioType() const { return _scenario_type; }
    QString controlLoopType() const { return _controlLoopType; }

    void setDt(double dt);
    void setScenarioType(const QString &type);
    void setControlLoopType(const QString &type);

signals:
    void responseChanged(double newResponse);
    void dtChanged(double newDt);
    void setpointChanged(double newSetpoint);
    void overshootChanged(double newOvershoot);
    void scenarioTypeChanged();
    void scenarioConfigurationError(const QString &error);
    void controllerConfigurationError(const QString &error);
    void controlLoopTypeChanged();

private:
    void update();
    void makeControlLoop(const QString &type);

    std::unique_ptr<ControlLoop> _control_loop;
    std::unique_ptr<Scenario> _scenario;
    ResponseMetrics _response_metrics;
    double _dt {0.01};
    float _response {0.0};
    double _setpoint {0.0};
    QString _scenario_type {"pitch-step"};
    QString _controlLoopType {"pid"};

    QVariantMap _controller_params {
        {QStringLiteral("kp"), 1.5},
        {QStringLiteral("ki"), 0.05},
        {QStringLiteral("kd"), 0.4}
    };
    
    QTimer _simulation_timer;
};

#endif // FLIGHT_SIMULATION_H