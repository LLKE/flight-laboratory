#include "flight_simulation.h"


FlightSimulation::FlightSimulation(std::unique_ptr<ControlLoop> loop, double dt, QObject *parent)
: _control_loop(std::move(loop)), _dt(dt), QObject(parent)
{
    _simulation_timer.setInterval(_dt * 1000);
    connect(&_timer, &QTimer::timeout, this, &FlightSimulation::update())
}

void FlightSimulation::update() {
    _control_loop.update(_dt);
}