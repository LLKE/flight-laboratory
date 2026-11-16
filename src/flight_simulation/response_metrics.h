#ifndef RESPONSE_METRICS_H
#define RESPONSE_METRICS_H

class ResponseMetrics
{
public:
    void reset(double initialReference);
    bool observe(double reference, double response);

    double overshoot() const { return _overshoot; }

private:
    double _previous_reference {};
    double _step_target {};
    double _step_direction {};
    double _overshoot {};
    bool _has_step {};
};

#endif // RESPONSE_METRICS_H
