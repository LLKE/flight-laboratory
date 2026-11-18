#ifndef FLIGHT_LAB_ENGINE_H
#define FLIGHT_LAB_ENGINE_H

class FlightLabEngine
{
public:
    virtual ~FlightLabEngine() = default;

    virtual void step(double dt) = 0;
    virtual void reset() = 0;
};

#endif // FLIGHT_LAB_ENGINE_H
