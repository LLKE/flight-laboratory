#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "basicdynamicssim.h"

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

    BasicDynamicsSim* rollGenerator = new BasicDynamicsSim();

    return QGuiApplication::exec();
}
