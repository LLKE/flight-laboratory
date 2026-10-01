# PID Controller

## What a PID controller is

A PID controller is a feedback controller used to make a system follow a target value, called the setpoint. It does this by measuring the current value, comparing it to the setpoint, and computing a corrective control signal.

The error is defined as:

$$
error = setpoint - measurement
$$

The controller then combines three effects:

- Proportional: reacts to the current error
- Integral: accumulates past error over time
- Derivative: reacts to how quickly the error is changing

The total control signal is:

$$
control = K_p \cdot error + K_i \cdot \int error\,dt + K_d \cdot \frac{de}{dt}
$$

This is the standard form of a PID controller, and the implementation in this project follows that structure.

## Meaning of the parameters

Each parameter changes how strongly one part of the controller reacts:

### Proportional gain $K_p$

This term responds immediately to the current error. A larger $K_p$ gives a stronger correction and usually makes the system react faster, but it can also cause overshoot or oscillation.

### Integral gain $K_i$

This term accumulates error over time. It helps remove a constant offset that remains even after a proportional response. A larger $K_i$ increases the correction for persistent error, but it can also make the system slower or more oscillatory if it is too high.

### Derivative gain $K_d$

This term reacts to the rate at which the error changes. It adds damping and helps reduce oscillation, but it is sensitive to noise and changes quickly when the error moves rapidly.

## How the implementation works

The implementation in `src/control/controllers/pid.h` and `src/control/controllers/pid.cpp` is a discrete-time PID controller. In other words, it updates once per time step with a time interval `dt`.

The calculation is performed in `calcControlCommand`:

```cpp
const float error = setpoint - measurement;
_integral += error * dt;

_control_command = _p * error + _i * _integral + _d * (error - _error_prev) / dt;
_error_prev = error;
```

This matches the discrete PID structure:

- `error` is the current difference between target and measured value
- `_integral += error * dt` accumulates the error over time
- `(error - _error_prev) / dt` approximates the derivative of the error
- the three terms are added to form the final command

## Role of each stored value

The controller stores several internal values:

```cpp
const float _p;
const float _i;
const float _d;

float _control_command {};
float _error_prev {};
float _integral {};
```

These are used as follows:

- `_p`, `_i`, `_d` store the gain values
- `_integral` accumulates the error over time
- `_error_prev` stores the previous error so the derivative can be estimated
- `_control_command` stores the output of the current update step

## Use in the Flight Laboratory loop

The controller is used inside the PID control loop in `src/control/loops/pid_control_loop.cpp`:

```cpp
const float setpoint = _step_pilot.generateSetpoint(dt);
const float measurement = _model.getPrevValue();
const float control_command = _pid_controller.getControlCommand(setpoint, measurement, dt);
const float pitch_value = _model.getValue(control_command, dt);
```

This means:

1. the [virtual pilot](/Docs/docs/control/virtual-pilot.md) generates a target value,
2. the current model value is measured,
3. the PID controller computes a corrective signal,
4. the model updates using that signal.

In other words, the PID loop is regulating the simulated pitch value toward the commanded setpoint.

## Notes about the current implementation

The constructor also accepts actuator constraints:

```cpp
PIDController(std::vector<float> actuator_constraints, float p, float i, float d);
```

These are stored in `_actuator_constraints`, but in the current implementation they are not used to limit or clamp the output value during the control calculation.

## Summary

A PID controller is a standard feedback method for reducing the difference between the desired value and the measured value. In this project, the controller computes the error, accumulates it for the integral term, estimates its rate of change for the derivative term, and combines all three parts into one control command.

The result is a standard discrete PID control law that is applied directly in the simulation loop to drive the pitch model toward the desired setpoint.
