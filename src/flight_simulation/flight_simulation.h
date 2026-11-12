#ifndef FLIGHT_SIMULATION_H
#define FLIGHT_SIMULATION_H

#include <memory>

#include <QObject>
#include <QTimer>
#include <QString>

#include <QtQml/qqmlregistration.h>

#include "src/control/loops/control_loop.h"
#include "param_sets.h"

class FlightSimulation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double pitch READ pitch NOTIFY pitchChanged)
    Q_PROPERTY(double setpoint READ setpoint NOTIFY setpointChanged)
    Q_PROPERTY(QString controlLoopType READ controlLoopType WRITE setControlLoopType NOTIFY controlLoopTypeChanged)
    Q_PROPERTY(double dt READ dt WRITE setDt NOTIFY dtChanged)
    QML_ELEMENT

public:
    explicit FlightSimulation(QObject *parent = nullptr);

    // Entry points for controller params from QML
    Q_INVOKABLE void setPidParams(float kp, float ki, float kd);
    Q_INVOKABLE void restartSim();

    // Entry points for virtual pilot manipulation from QML
    Q_INVOKABLE void setNewSetpointMagnitude(const float magnitude);

    double pitch() const { return _pitch; }
    double dt() const { return _dt; }
    double setpoint() const { return _setpoint; }
    QString controlLoopType() const { return _controlLoopType; }

    void setDt(double dt);
    void setControlLoopType(const QString &type);

signals:
    void pitchChanged(double newPitch);
    void dtChanged(double newDt);
    void setpointChanged(double newSetpoint);
    void controlLoopTypeChanged();

private:
    void update();
    void makeControlLoop(const QString &type);

    std::unique_ptr<ControlLoop> _control_loop;
    double _dt {0.01};
    float _pitch {0.0};
    double _setpoint {0.0};
    QString _controlLoopType {"pid"};

    // TODO: Make controller type agnostic
    PIDParams _pid_params {1.5f, 0.05f, 0.4f};
    
    QTimer _simulation_timer;
};

#endif // FLIGHT_SIMULATION_H