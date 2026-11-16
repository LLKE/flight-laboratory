#ifndef RESPONSE_METRICS_H
#define RESPONSE_METRICS_H

#include "scenario.h"

class ResponseMetrics
{
public:
    void reset();
    bool observe(const std::optional<ReferenceChange> &referenceChange, double response);

    double overshoot() const { return _overshoot; }

private:
    double _step_target {};
    double _step_direction {};
    double _overshoot {};
    bool _has_step {};
};

#endif // RESPONSE_METRICS_H
