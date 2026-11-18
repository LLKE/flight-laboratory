#ifndef FLIGHT_LAB_ADAPTER_H
#define FLIGHT_LAB_ADAPTER_H

#include <memory>

#include <QObject>
#include <QString>
#include <QTimer>

#include "flight_lab_engine/flight_lab_engine.h"

class FlightLabAdapter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double dt READ dt WRITE setDt NOTIFY dtChanged)

public:
    explicit FlightLabAdapter(std::unique_ptr<FlightLabEngine> engine,
                              QObject *parent = nullptr);

    Q_INVOKABLE void restartEngine();

    double dt() const { return _dt; }
    void setDt(double dt);

signals:
    void dtChanged(double newDt);
    void engineError(const QString &error);
    void engineStepped();
    void engineReset();

protected:
    FlightLabEngine &engine() { return *_engine; }
    void startEngine();

private:
    void advanceEngine();

    std::unique_ptr<FlightLabEngine> _engine;
    QTimer _engine_timer;
    double _dt {0.01};
};

#endif // FLIGHT_LAB_ADAPTER_H
