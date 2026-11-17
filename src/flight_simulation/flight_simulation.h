#ifndef PID_LAB_SIM_H
#define PID_LAB_SIM_H

#include <memory>
#include <string>

#include "src/control/loops/control_loop.h"
#include "response_metrics.h"
#include "scenario.h"

class FlightSimulation {

public:
    // explicit FlightSimulation(QObject *parent = nullptr);

private:
    void update();
    void makeControlLoop(const std::string &type);

    ResponseMetrics _response_metrics;
    double _dt {0.01};
};

#endif // PID_LAB_SIM_H