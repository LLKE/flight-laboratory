#ifndef FLIGHT_SIMULATION_H
#define FLIGHT_SIMULATION_H

#include <memory>

#include <QObject>
#include <QTimer>
#include <QString>

#include <QtQml/qqmlregistration.h>

#include "src/control/loops/control_loop.h"

class FlightSimulation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double pitch READ pitch NOTIFY pitchChanged)
    Q_PROPERTY(QString controlLoopType READ controlLoopType WRITE setControlLoopType NOTIFY controlLoopTypeChanged)
    Q_PROPERTY(double dt READ dt WRITE setDt NOTIFY dtChanged)
    QML_ELEMENT

public:
    explicit FlightSimulation(QObject *parent = nullptr);

    double pitch() const { return _pitch; }
    double dt() const { return _dt; }
    QString controlLoopType() const { return _controlLoopType; }

    void setDt(double dt);
    void setControlLoopType(const QString &type);

signals:
    void pitchChanged(double newPitch);
    void dtChanged(double newDt);
    void controlLoopTypeChanged();

private:
    void update();
    void makeControlLoop(const QString &type);

    std::unique_ptr<ControlLoop> _control_loop;
    double _dt {0.01};
    double _pitch {0.0};
    QString _controlLoopType {"pid"};
    QTimer _simulation_timer;
};

#endif // FLIGHT_SIMULATION_H