#include "response_metrics.h"

#include <algorithm>

void ResponseMetrics::reset(double initialReference)
{
    _previous_reference = initialReference;
    _step_target = initialReference;
    _step_direction = 0.0;
    _overshoot = 0.0;
    _has_step = false;
}

bool ResponseMetrics::observe(double reference, double response)
{
    const double previousOvershoot = _overshoot;

    if (reference != _previous_reference) {
        _step_target = reference;
        _step_direction = reference > _previous_reference ? 1.0 : -1.0;
        _overshoot = 0.0;
        _has_step = true;
        _previous_reference = reference;
    }

    if (_has_step) {
        _overshoot = std::max(_overshoot, _step_direction * (response - _step_target));
    }

    return _overshoot != previousOvershoot;
}
