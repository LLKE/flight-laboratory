#include "basicdynamicssim.h"

BasicDynamicsSim::BasicDynamicsSim(QObject *parent)
    : QObject(parent),
    m_frequency(1.0),
    m_amplitude(20.0),
    m_roll(0.0),
    m_currentTime(0.0),
    m_timeStep(0.02)
{
    rollUpdateTimer = new QTimer(this); // Pass "this" as parent for memory management

    // connect timer with its timeout signal to BasicDynamicsSim with its simRollSin function
    connect(rollUpdateTimer, &QTimer::timeout, this, &BasicDynamicsSim::simRollSin);

    rollUpdateTimer->setInterval(20);
    rollUpdateTimer->start();
}

void BasicDynamicsSim::simRollSin() {
    const double PI = std::acos(-1);
    m_roll = m_amplitude * qSin(2 * PI * m_frequency * m_currentTime);
    m_currentTime += m_timeStep;
    emit rollChanged(m_roll);
}
