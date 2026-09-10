#include "roll_sin_pilot.h"

RollSinPilot::RollSinPilot()
    : m_frequency(1.0),
    m_amplitude(20.0),
    m_roll(0.0),
    m_currentTime(0.0),
    m_timeStep(0.02)
{}

void RollSinPilot::simRollSin() {
    const double PI = std::acos(-1);
    m_roll = m_amplitude * qSin(2 * PI * m_frequency * m_currentTime);
    m_currentTime += m_timeStep;
    emit rollChanged(m_roll);
}
