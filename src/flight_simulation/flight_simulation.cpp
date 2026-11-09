#include "flight_simulation/flight_simulation.h"

#include "control/loops/pid_control_loop.h"

FlightSimulation::FlightSimulation(QObject *parent)
    : QObject(parent)
{
    _simulation_timer.setInterval(_dt * 1000);
    connect(&_simulation_timer, &QTimer::timeout, this, &FlightSimulation::update);
    makeControlLoop(_controlLoopType);
    _simulation_timer.start();
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
    Q_UNUSED(type);
    _control_loop = std::make_unique<pidControlLoop>();
    _control_loop->updateControllerParams(ControllerParams{_pid_params});
}

void FlightSimulation::update()
{
    if (_control_loop) {
        //TODO: this can only simulate pitch -> make universal
        const float pitch_value = _control_loop->update(_dt);
        _pitch = pitch_value;
        _setpoint = _control_loop->getSetpoint();
        emit pitchChanged(_pitch);
        emit setpointChanged(_setpoint);
    }
}

void FlightSimulation::setPidParams(float kp, float ki, float kd)
{
    _pid_params = {kp, ki, kd};
    if (!_control_loop) {
        return;
    }
    
    _control_loop->updateControllerParams(ControllerParams{_pid_params});
}

void FlightSimulation::restartSim()
{
    _simulation_timer.stop();
    makeControlLoop(_controlLoopType);
    _pitch = 0.0f;
    _setpoint = 0.0;
    emit pitchChanged(_pitch);
    emit setpointChanged(_setpoint);
    _simulation_timer.start();
}