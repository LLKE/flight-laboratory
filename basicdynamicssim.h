#ifndef BASICDYNAMICSSIM_H
#define BASICDYNAMICSSIM_H

#include <QObject>
#include <QTimer>
#include <QtMath>
#include <QDebug>
#include <QtQml/QQmlEngine>

class BasicDynamicsSim : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(float roll READ roll NOTIFY rollChanged FINAL)

public:
    explicit BasicDynamicsSim(QObject *parent = nullptr);

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

#endif // BASICDYNAMICSSIM_H
