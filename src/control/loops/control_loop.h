#ifndef CONTROL_LOOP_H
#define CONTROL_LOOP_H

#include <QString>
#include <QVariantMap>

class ControlLoop {

public:
    ControlLoop() {};  

    virtual float update(float setpoint, double dt) = 0;
    virtual float controlCommand() const { return 0.0f; }

    virtual bool updateControllerParams(const QVariantMap &params, QString &error) = 0;
    virtual void updateModelParams() = 0;
};

#endif // CONTROL_LOOP_H