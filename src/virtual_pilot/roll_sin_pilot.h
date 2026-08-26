#ifndef ROLLSINPILOT_H
#define ROLLSINPILOT_H

#include <QObject>
#include <QTimer>
#include <QtMath>
#include <QDebug>
#include <QtQml/QQmlEngine>

#include "virtual_pilot.h"

class RollSinPilot : public QObject, public VirtualPilot
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(float roll READ roll NOTIFY rollChanged FINAL)

public:
    explicit RollSinPilot(QObject *parent = nullptr);

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
    QTimer* rollUpdateTimer;

};

#endif // ROLLSINPILOT_H
