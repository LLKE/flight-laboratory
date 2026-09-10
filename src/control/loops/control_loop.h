#ifndef CONTROL_LOOP_H
#define CONTROL_LOOP_H


class ControlLoop {

public:
    ControlLoop();  

    virtual void update(double dt) = 0;
protected:
}

#endif // CONTROL_LOOP_H