#ifndef FLIGHT_SIMULAITON_H
#define FLIGHT_SIMULATION_H

#include <memory> 

#include <QObject>
#include <QTimer>

#include "src/control/loops/control_loop.h"

class FlightSimulation 
{
    Q_OBJECT
    Q_PROPERTY( pitch READ pitch NOTIFY pitchChanged())

public:
    explicit FlightSimulation(std::unique_ptr<ControlLoop> loop, double dt, QObject *parent = nullptr);

    float pitch() const {return _pitch};

signals:
    void pitchChanged(double newPitch);

private:
    std::unique_ptr<ControlLoop> _control_loop;
    
    double  {0.01};
    double _pitch;

    QTimer _simulation_timer;
    
    virtual void update();
};

#endif // FLIGHT_SIMULATION_H