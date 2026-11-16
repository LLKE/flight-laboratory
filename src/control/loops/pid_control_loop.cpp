#include "pid_control_loop.h"

#include <cmath>
#include <iostream>

pidControlLoop::pidControlLoop(){}

float pidControlLoop::update(float setpoint, double dt) {
    const float measurement = _model.getPrevValue();
    const float control_command = _pid_controller.getControlCommand(setpoint, measurement, dt);
    const float pitch_value = _model.getValue(control_command, dt);

    return pitch_value;
}

bool pidControlLoop::updateControllerParams(const QVariantMap &params, QString &error) {
    const char *const names[] = { "kp", "ki", "kd" };
    for (auto it = params.cbegin(); it != params.cend(); ++it) {
        if (it.key() != QLatin1String("kp") &&
            it.key() != QLatin1String("ki") &&
            it.key() != QLatin1String("kd")) {
            error = QStringLiteral("Unsupported PID controller parameter: %1").arg(it.key());
            return false;
        }
    }

    float values[3];
    int index = 0;
    for (const char *name : names) {
        const auto it = params.constFind(QLatin1String(name));
        if (it == params.cend()) {
            error = QStringLiteral("Missing PID controller parameter: %1").arg(QLatin1String(name));
            return false;
        }
        bool converted = false;
        const float value = it->toFloat(&converted);
        if (!converted || !std::isfinite(value)) {
            error = QStringLiteral("Invalid PID controller parameter: %1").arg(QLatin1String(name));
            return false;
        }
        values[index++] = value;
    }

    _pid_controller.setControlParams(values[0], values[1], values[2]);
    return true;
}

void pidControlLoop::updateModelParams()
{}