#include "flight_lab_adapter.h"

#include <cmath>
#include <limits>
#include <stdexcept>
#include <utility>

FlightLabAdapter::FlightLabAdapter(std::unique_ptr<FlightLabEngine> engine,
                                   QObject *parent)
    : QObject(parent),
      _engine(std::move(engine))
{
    if (!_engine) {
        throw std::invalid_argument("FlightLabAdapter requires an engine");
    }

    _engine_timer.setInterval(static_cast<int>(_dt * 1000));
    connect(&_engine_timer, &QTimer::timeout, this, &FlightLabAdapter::advanceEngine);
}

void FlightLabAdapter::setDt(double dt)
{
    const double intervalMilliseconds = dt * 1000.0;
    if (!std::isfinite(dt) || dt < 0.001
        || !std::isfinite(intervalMilliseconds)
        || intervalMilliseconds > std::numeric_limits<int>::max()) {
        emit engineError(
            QStringLiteral("Timestep must be between 0.001 seconds and the timer's maximum interval"));
        return;
    }
    if (_dt == dt) {
        return;
    }

    _dt = dt;
    _engine_timer.setInterval(static_cast<int>(intervalMilliseconds));
    emit dtChanged(_dt);
}

void FlightLabAdapter::restartEngine()
{
    _engine_timer.stop();
    _engine->reset();
    emit engineReset();
    _engine_timer.start();
}

void FlightLabAdapter::startEngine()
{
    _engine_timer.start();
}

void FlightLabAdapter::advanceEngine()
{
    _engine->step(_dt);
    emit engineStepped();
}
