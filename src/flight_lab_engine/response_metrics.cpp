#include "response_metrics.h"

#include <algorithm>
#include <cmath>

void ResponseMetrics::reset()
{
    _step_target = 0.0;
    _step_magnitude = 0.0;
    _step_direction = 0.0;
    _overshoot = 0.0;
    _settling_time = 0.0;
    _steady_state_error = 0.0;
    _elapsed_time = 0.0;
    _step_start_time = 0.0;
    _last_outside_time = 0.0;
    _has_step = false;
}

bool ResponseMetrics::observe(const std::optional<ReferenceChange> &referenceChange,
                              double response, double dt)
{
    _elapsed_time += dt;
    bool changed = false;
    if (referenceChange) {
        _step_target = referenceChange->to;
        _step_magnitude = std::abs(referenceChange->to - referenceChange->from);
        _step_direction = referenceChange->to > referenceChange->from ? 1.0 : -1.0;
        _overshoot = 0.0;
        _settling_time = 0.0;
        _step_start_time = _elapsed_time;
        _last_outside_time = _elapsed_time;
        _has_step = true;
        changed = true;
    }

    if (_has_step) {
        const double overshoot = std::max(0.0, _step_direction * (response - _step_target));
        if (overshoot > _overshoot) {
            _overshoot = overshoot;
            changed = true;
        }

        const double settlingTolerance = settlingToleranceRatio * _step_magnitude;
        if (std::abs(response - _step_target) > settlingTolerance) {
            _last_outside_time = _elapsed_time;
        }
        const double settlingTime = std::max(0.0, _last_outside_time - _step_start_time);
        if (settlingTime != _settling_time) {
            _settling_time = settlingTime;
            changed = true;
        }

        const double steadyStateError = _step_target - response;
        if (steadyStateError != _steady_state_error) {
            _steady_state_error = steadyStateError;
            changed = true;
        }
    }

    return changed;
}
