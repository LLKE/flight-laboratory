#include <memory>

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "flight_simulation/flight_simulation.h"
#include "control/loops/pid_control_loop.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("FlightLaboratory", "Main");
    std::unique_ptr<pidControlLoop> loop = std::make_unique<pidControlLoop>();
    FlightSimulation* flightSimulation = new FlightSimulation(loop, 0.01);

    return QGuiApplication::exec();
}
