#ifndef FLIGHT_SIMULATION_H
#define FLIGHT_SIMULATION_H

#include <memory>

#include <QObject>
#include <QTimer>

#include "src/control/loops/control_loop.h"

class FlightSimulation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double pitch READ pitch NOTIFY pitchChanged)

public:
    explicit FlightSimulation(
        std::unique_ptr<ControlLoop> loop,
        double dt,
        QObject *parent = nullptr);

    double pitch() const { return _pitch; }

signals:
    void pitchChanged(double newPitch);

private:
    std::unique_ptr<ControlLoop> _control_loop;
    double _dt {0.01};
    double _pitch {0.0};
    QTimer _simulation_timer;

    void update();
};

#endif // FLIGHT_SIMULATION_H