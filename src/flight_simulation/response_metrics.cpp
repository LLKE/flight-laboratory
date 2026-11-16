#include "response_metrics.h"

#include <algorithm>

void ResponseMetrics::reset()
{
    _step_target = 0.0;
    _step_direction = 0.0;
    _overshoot = 0.0;
    _has_step = false;
}

bool ResponseMetrics::observe(const std::optional<ReferenceChange> &referenceChange,
                              double response)
{
    bool changed = false;
    if (referenceChange) {
        _step_target = referenceChange->to;
        _step_direction = referenceChange->to > referenceChange->from ? 1.0 : -1.0;
        _overshoot = 0.0;
        _has_step = true;
        changed = true;
    }

    if (_has_step) {
        const double overshoot = std::max(0.0, _step_direction * (response - _step_target));
        if (overshoot > _overshoot) {
            _overshoot = overshoot;
            changed = true;
        }
    }

    return changed;
}
