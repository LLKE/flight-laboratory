#ifndef ROLLSINPILOT_H
#define ROLLSINPILOT_H

#include <QtQml/QQmlEngine>

#include "virtual_pilot.h"

class RollSinPilot : public VirtualPilot
{

public:
    explicit RollSinPilot();

    float roll() const { return m_roll; }

private slots:
    void simRollSin();

signals:
    void rollChanged(double newRoll);

private:
    float m_roll {};
    float m_frequency {};
    float m_amplitude {};
    float m_timeStep {};
    float m_currentTime {};
};

#endif // ROLLSINPILOT_H
