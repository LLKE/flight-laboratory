# Virtual Pilot

A virtual pilot is a software component that produces a setpoint for a downstream part of the flight-control pipeline. It replaces the pilot's setpoint input with a repeatable signal, which is useful for simulations, controller experiments, and other applications that need a commanded value.

## Contract

[`VirtualPilot`](../../../src/virtual_pilot/virtual_pilot.h) is the abstract base class. A concrete pilot implements:

- `generateSetpoint(double dt)`, which advances its internal state by the elapsed simulation time and returns the current setpoint.
- `getSetpoint()`, which returns the latest setpoint without advancing the pilot.

The base class stores the latest value in `_setpoint`. The interface uses `float` values, so the meaning and units of a setpoint are established by the consumer. In PID Lab, for example, the pitch control loop uses the pilot's value as the controller target.

`dt` is in seconds in the current simulation. `FlightSimulation` defaults to a `dt` of `0.01` and uses it both to schedule updates and as the timestep passed through the control loop. A pilot should use the supplied timestep rather than assuming a fixed update rate.

## Pitch Step Pilot

[`PitchStepPilot`](../../../src/virtual_pilot/pitch_step_pilot.h) generates a step signal. It accumulates each supplied `dt`; before the configured delay has elapsed, the setpoint is zero, and at or after the delay it becomes the configured magnitude. The value remains at that magnitude on subsequent calls.

The default constructor configures a delay of zero and a magnitude of `30`. The two-argument constructor accepts `(delay, magnitude)`. Both values are currently plain floats; the caller is responsible for choosing a delay in seconds and a magnitude in the units expected by its consumer.

The PID control loop calls `generateSetpoint(dt)` once per update, supplies the returned value to the PID controller, then exposes the pilot's current setpoint to the simulation. This keeps setpoint generation separate from control and plant dynamics.

## Adding a Pilot

Derive from `VirtualPilot` and implement both methods. Keep time-dependent state inside the pilot, advance it using `dt`, and update `_setpoint` before returning the result. Consumers can then hold a concrete pilot or use it behind the common interface, and read its value without advancing its state.

For example, a future sinusoidal pilot could calculate a new value from its phase and elapsed time in `generateSetpoint(dt)`, while `getSetpoint()` simply returns the most recently generated value.

## Current Roll Pilot Status

[`RollSinPilot`](../../../src/virtual_pilot/roll_sin_pilot.h) is not currently an implementation of the `VirtualPilot` contract: it does not override `generateSetpoint` or `getSetpoint`, and its `simRollSin()` helper is private and is not called by the class. Its roll signal generation should therefore be considered incomplete and it is not currently used by the control-loop pipeline.