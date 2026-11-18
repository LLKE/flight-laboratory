#ifndef RESPONSE_METRICS_H
#define RESPONSE_METRICS_H

#include "scenario.h"

class ResponseMetrics
{
public:
    void reset();
    bool observe(const std::optional<ReferenceChange> &referenceChange, double response, double dt);

    double overshoot() const { return _overshoot; }
    double settlingTime() const { return _settling_time; }
    double steadyStateError() const { return _steady_state_error; }

private:
    static constexpr double settlingToleranceRatio = 0.02;

    double _step_target {};
    double _step_magnitude {};
    double _step_direction {};
    double _overshoot {};
    double _settling_time {};
    double _steady_state_error {};
    double _elapsed_time {};
    double _step_start_time {};
    double _last_outside_time {};
    bool _has_step {};
};

#endif // RESPONSE_METRICS_H
