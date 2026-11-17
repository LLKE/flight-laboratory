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

class FlightLabAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double dt READ dt WRITE setDt NOTIFY dtChanged)
    QML_ELEMENT

public:
    explicit FlightLabAdapter(QObject *parent = nullptr);

    Q_INVOKABLE void restartSim();

    double dt() const { return _dt; }

    void setDt(double dt);

signals:
    void dtChanged(double newDt);

private:
    void update();

    double _dt {0.01};
    
    QTimer _simulation_timer;
};

#endif // FLIGHT_SIMULATION_H