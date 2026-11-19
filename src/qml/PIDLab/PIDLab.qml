import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QtCharts

import FlightLaboratory as FL

import "../BasicComponents/" as BC

Item {
    id: root

    property var padding: 5

    function applyPidParams(pValue, iValue, dValue) {
        pidLabAdapter.setControllerParams({
            kp: pValue,
            ki: iValue,
            kd: dValue
        })
    }

    function applySetpointChange(value) {
        pidLabAdapter.configureScenario({ magnitude: value })
    }

    function applyPitchModelParams(pitchDamping, elevatorEffectiveness) {
        pidLabAdapter.setModelParams({
            pitch_damping: pitchDamping,
            elevator_effectiveness: elevatorEffectiveness
        })
    }

    function restartEngine() {
        pidLabAdapter.restartEngine()
        timeTracker.simTime = 0.0
        actualSeries.clear()
        targetSeries.clear()
        xAxis.min = 0.0
        xAxis.max = 10.0
    }

    function rerunSimulation() {
        applyPidParams(pSlider.value, iSlider.value, dSlider.value)
        applySetpointChange(setpointSlider.value)
        applyPitchModelParams(
            pitchDampingSlider.value,
            elevatorEffectivenessSlider.value
        )
        restartEngine()
    }

    FL.PidLabAdapter {
        id: pidLabAdapter
        controlLoopType: "pid"
        dt: 0.01

        // Create response/time datapoint to append to time series
        onResponseChanged: {
            timeTracker.simTime += pidLabAdapter.dt
            actualSeries.append(timeTracker.simTime, pidLabAdapter.response)
            
            // Keep dynamic rolling window
            if (timeTracker.simTime > xAxis.max) {
                xAxis.min = timeTracker.simTime - 10.0
                xAxis.max = timeTracker.simTime
            }
        }

        onSetpointChanged: {
            targetSeries.append(timeTracker.simTime, pidLabAdapter.setpoint)
            
            // Keep dynamic rolling window
            if (timeTracker.simTime > xAxis.max) {
                xAxis.min = timeTracker.simTime - 10.0
                xAxis.max = timeTracker.simTime
            }
        }
    }

    Connections {
        target: pidLabAdapter

        function onControllerConfigurationError(error) {
            console.error(error)
        }

        function onModelConfigurationError(error) {
            console.error(error)
        }
    }

    QtObject {
        id: timeTracker
        property real simTime: 0.0
    }
    
    RowLayout {

        anchors.fill: parent
        anchors.margins: parent.width / 100
        spacing: parent.width / 100

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: root.width / 3
            Layout.minimumWidth: 0
            spacing: parent.height / 100

            BC.TitledFrame {
                id: controls

                title: "PID Parameters"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 3 * root.height / 7
                Layout.minimumHeight: 0

                ColumnLayout {
                    id: sliders 

                    anchors.fill: parent
                    
                    BC.LabelledSlider {
                        id: pSlider

                        title: "P"
                        from: 0
                        to: 2
                        value: 1.5

                        Layout.fillWidth: true
                    }
                    
                    BC.LabelledSlider {
                        id: iSlider

                        title: "I"
                        from: 0
                        to: 2.0
                        value: 0.05

                        Layout.fillWidth: true
                    }

                    BC.LabelledSlider {
                        id: dSlider

                        title: "D"
                        from: 0
                        to: 1
                        value: 0.4

                        Layout.fillWidth: true
                    }

                    Button {
                        text: "Tuning methods"

                        onClicked: tuningGuide.open()
                    }

                    Component.onCompleted: {
                        applyPidParams(pSlider.value, iSlider.value, dSlider.value);
                    }
                }
            }

            BC.TitledFrame {
                title: "Pitch Setpoint Magnitude"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: root.height / 7
                Layout.minimumHeight: 0

                BC.LabelledSlider {
                    id: setpointSlider

                    title: ""
                    from: 0
                    to: 45
                    value: 45

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                }

            }

            BC.TitledFrame {
                title: "Pitch Model Parameters"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 2 * root.height / 7
                Layout.minimumHeight: 0

                ColumnLayout {
                    anchors.fill: parent

                    BC.LabelledSlider {
                        id: pitchDampingSlider

                        title: "Pitch damping"
                        from: 0
                        to: 2
                        value: pidLabAdapter.pitchDamping
                        Layout.fillWidth: true
                    }

                    BC.LabelledSlider {
                        id: elevatorEffectivenessSlider

                        title: "Elevator effectiveness"
                        from: 0
                        to: 2
                        value: pidLabAdapter.elevatorEffectiveness
                        Layout.fillWidth: true
                    }
                }
            }

            BC.TitledFrame {
                id: rerunControls

                title: "Controls"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: root.height / 7
                Layout.minimumHeight: 0

                RowLayout {
                    anchors.fill: parent

                    Button {
                        text: "Rerun"
                        Layout.alignment: Qt.AlignHCenter

                        onClicked: root.rerunSimulation()
                    }
                }
            }
        }

        ColumnLayout {
            Layout.preferredWidth: root.width / 3
            Layout.fillHeight: true
            spacing: parent.height / 50
            
            ArtificialHorizion {
                id: artificialHorizion
                visible: true
                pitch: pidLabAdapter.response
                roll: 0
                
                // Layout.margins: -root.width / 50
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PIDControlLoopDisplay {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }

        ColumnLayout {

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth:  root.width / 3
            Layout.minimumWidth: 0
            spacing: parent.height / 50

            Item {
                id: controlChart
                Layout.fillWidth: true
                Layout.preferredHeight: root.height / 2
                Layout.fillHeight: true
                Layout.minimumWidth: 0
                Layout.minimumHeight: 0

                ChartView {
                    id: chart

                    anchors.fill: parent

                    theme: ChartView.ChartThemeDark 
                    antialiasing: true
                    animationOptions: ChartView.NoAnimation
                    
                    ValueAxis {
                        id: xAxis
                        titleText: "Simulation Time (s)"
                        min: 0.0
                        max: 10.0
                        tickCount: 6
                        labelFormat: "%.1f"
                    }

                    ValueAxis {
                        id: yAxis
                        titleText: "Pitch Angle"
                        min: -90
                        max: 90
                        tickCount: 5
                    }

                    LineSeries {
                        id: targetSeries
                        name: "Pitch Setpoint"
                        axisX: xAxis
                        axisY: yAxis
                        color: "#FF5722"
                        width: 2
                    }

                    LineSeries {
                        id: actualSeries
                        name: "Pitch Actual"
                        axisX: xAxis
                        axisY: yAxis
                        color: "#4CAF50"
                        width: 3
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: root.height / 2
                Layout.minimumWidth: 0
                Layout.minimumHeight: 0

                BC.TitledFrame {
                    title: "Telemetry"
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    GridLayout {
                        id: telemetryGrid
                        anchors.fill: parent
                        columns: 2

                        property real uniformTelemetryHeight: Math.max(
                            pitchTelemetry.implicitHeight,
                            overshootTelemetry.implicitHeight,
                            settlingTimeTelemetry.implicitHeight,
                            steadyStateErrorTelemetry.implicitHeight,
                            controlEffortTelemetry.implicitHeight,
                            accumulatedControlEffortTelemetry.implicitHeight
                        )

                        BC.TelemetryDisplay {
                            id: pitchTelemetry
                            title: "Pitch"
                            value: pidLabAdapter.response
                            unit: "°"
                            decimals: 1
                            Layout.preferredHeight: telemetryGrid.uniformTelemetryHeight
                        }

                        BC.TelemetryDisplay {
                            id: overshootTelemetry
                            title: "Overshoot"
                            value: pidLabAdapter.overshoot
                            unit: "°"
                            decimals: 1
                            Layout.preferredHeight: telemetryGrid.uniformTelemetryHeight
                        }

                        BC.TelemetryDisplay {
                            id: settlingTimeTelemetry
                            title: "Settling Time"
                            value: pidLabAdapter.settlingTime
                            unit: "s"
                            decimals: 2
                            Layout.preferredHeight: telemetryGrid.uniformTelemetryHeight
                        }

                        BC.TelemetryDisplay {
                            id: steadyStateErrorTelemetry
                            title: "Steady State Error"
                            value: pidLabAdapter.steadyStateError
                            unit: "°"
                            decimals: 2
                            Layout.preferredHeight: telemetryGrid.uniformTelemetryHeight
                        }

                        BC.TelemetryDisplay {
                            id: controlEffortTelemetry
                            title: "Control Effort"
                            value: pidLabAdapter.controlEffort
                            unit: ""
                            decimals: 2
                            Layout.preferredHeight: telemetryGrid.uniformTelemetryHeight
                        }

                        BC.TelemetryDisplay {
                            id: accumulatedControlEffortTelemetry
                            title: "Accumulated Control Effort"
                            value: pidLabAdapter.accumulatedControlEffort
                            unit: "·s"
                            decimals: 2
                            Layout.preferredHeight: telemetryGrid.uniformTelemetryHeight
                        }
                    }
                }
            }
        }
    }

    PIDTuningGuide {
        id: tuningGuide
    }
}
