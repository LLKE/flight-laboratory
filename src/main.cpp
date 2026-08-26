#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "virtual_pilot/roll_sin_pilot.h"

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
    RollSinPilot* rollGenerator = new RollSinPilot();

    return QGuiApplication::exec();
}
