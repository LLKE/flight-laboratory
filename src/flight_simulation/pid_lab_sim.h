#ifndef PID_LAB_SIM_H
#define PID_LAB_SIM_H

#include "flight_simulation.h"

#include <memory>
#include <any>
#include <string>
#include <map>

#include "src/control/loops/control_loop.h"
#include "response_metrics.h"
#include "scenario.h"

class PidLabSimulation : public FlightSimulation {

public:
    // explicit FlightSimulation(QObject *parent = nullptr);

private:
    void update();
    void makeControlLoop(const std::string &type);

    std::unique_ptr<ControlLoop> _control_loop;
    std::unique_ptr<Scenario> _scenario;
    ResponseMetrics _response_metrics;
    double _dt {0.01};
    float _response {0.0};
    double _setpoint {0.0};
    double _control_effort {0.0};
    double _accumulated_control_effort {0.0};
    std::string _scenario_type {"pitch-step"};
    std::string _controlLoopType {"pid"};

    // std::map<std::string, std::any> _controller_params {
    //     {QStringLiteral("kp"), 1.5},
    //     {QStringLiteral("ki"), 0.05},
    //     {QStringLiteral("kd"), 0.4}
    // };  
};

#endif // PID_LAB_SIM_H