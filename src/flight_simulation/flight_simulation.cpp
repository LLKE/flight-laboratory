#include "flight_simulation/flight_simulation.h"

#include "control/loops/pid_control_loop.h"

FlightSimulation::FlightSimulation(QObject *parent)
    : QObject(parent)
{
    _simulation_timer.setInterval(_dt * 1000);
    connect(&_simulation_timer, &QTimer::timeout, this, &FlightSimulation::update);
    makeControlLoop(_controlLoopType);
}

void FlightSimulation::setDt(double dt)
{
    if (_dt == dt) {
        return;
    }

    _dt = dt;
    _simulation_timer.setInterval(_dt * 1000);
    emit dtChanged(_dt);
}

void FlightSimulation::setControlLoopType(const QString &type)
{
    if (_controlLoopType == type) {
        return;
    }

    _controlLoopType = type;
    makeControlLoop(type);
    emit controlLoopTypeChanged();
}

void FlightSimulation::makeControlLoop(const QString &type)
{
    if (type == "pid") {
        _control_loop = std::make_unique<pidControlLoop>();
    } else {
        _control_loop = std::make_unique<pidControlLoop>();
    }
}

void FlightSimulation::update()
{
    if (_control_loop) {
        _control_loop->update(_dt);
    }
}