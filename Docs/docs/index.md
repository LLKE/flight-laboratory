# Flight Laboratory

*UNDER CONSTRUCTION*

## What is Flight Laboratory?

Flight Laboratory is the sandbox software to learn about flight. 

It consists of a Qt-based GUI that is controlled by a C++ backend, and set up to allow creation of presets. A preset is a collection of related components that are useful to learn about a specific topic, e.g. an interface to input control parameters, and an artificial horizon for visualization.

The sky is the limit here (pun intended), as the idea is for it to be extensible, as mentioned, a sandbox.

## What is the Vision?

The opening statement may be quite broad, but indeed the idea is that it allows you to learn about, play with and develop your own flight-related software. From guidance, navigation and control to avionics UI development, or even interfacing with embedded devices.

## What does Flight Laboratory currently contain?

Currently, one preset is available, yet incomplete: PID Lab. The goal is to create a very simple flight dynamics model, as well as an attitude setpoint and a controller tasked with controlling the model to reach it. This is visualized using an artificial horizon (which exists), and a graph displaying controller output. 
