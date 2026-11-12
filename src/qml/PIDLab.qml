import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QtCharts

import FlightLaboratory as FL

import "BasicComponents/" as BC

Item {
    id: root

    property var padding: 5

    // TODO: add method to change setpoint magnitude
    // TODO: add method to change virtual pilot
    // TODO: make flight sim controller agnostic
    // TODO: add fields measuring overshoot, error etc.


    function applyPidParams(pValue, iValue, dValue) {
        flight_sim.setPidParams(
            pValue,
            iValue,
            dValue
        )
    }

    function applySetpointChange(value) {
        flight_sim.setNewSetpointMagnitude(value)
    }

    function restartSim() {
        flight_sim.restartSim()
        timeTracker.simTime = 0.0
        actualSeries.clear()
        targetSeries.clear()
        xAxis.min = 0.0
        xAxis.max = 10.0
    }

    FL.FlightSimulation {
        id: flight_sim
        controlLoopType: "pid"
        dt: 0.01

        // Create pitch/time datapoint to append to time series
        onPitchChanged: {
            timeTracker.simTime += flight_sim.dt
            actualSeries.append(timeTracker.simTime, flight_sim.pitch)
            
            // Keep dynamic rolling window
            if (timeTracker.simTime > xAxis.max) {
                xAxis.min = timeTracker.simTime - 10.0
                xAxis.max = timeTracker.simTime
            }
        }

        onSetpointChanged: {
            targetSeries.append(timeTracker.simTime, flight_sim.setpoint)
            
            // Keep dynamic rolling window
            if (timeTracker.simTime > xAxis.max) {
                xAxis.min = timeTracker.simTime - 10.0
                xAxis.max = timeTracker.simTime
            }
        }
    }

    QtObject {
        id: timeTracker
        property real simTime: 0.0
    }
    
    RowLayout {

        anchors.fill: parent

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: root.height / 10

            Frame {
                id: controls
                
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    text: "PID Parameters"
                    font.pixelSize: 15
                    color: "white"
                    // anchors.left: parent.left
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.margins: root.padding
                }

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
                        Layout.fillHeight: true
                    }
                    
                    BC.LabelledSlider {
                        id: iSlider

                        title: "I"
                        from: 0
                        to: 2.0
                        value: 0.05

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    BC.LabelledSlider {
                        id: dSlider

                        title: "D"
                        from: 0
                        to: 1
                        value: 0.4

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Button {
                        text: "Rerun"

                        onClicked: {
                            applyPidParams(pSlider.value, iSlider.value, dSlider.value);
                            restartSim();
                        }
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

            Frame {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    text: "Pitch Setpoint Magnitude"
                    font.pixelSize: 15
                    color: "white"
                    // anchors.left: parent.left
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.margins: root.padding
                }

                BC.LabelledSlider {
                    id: setpointSlider

                    title: ""
                    from: 0
                    to: 45
                    value: 15

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                }

                Button {
                    text: "Rerun"

                    anchors.top: setpointSlider.bottom
                    anchors.topMargin: parent.height / 5

                    onClicked: {
                        applySetpointChange(setpointSlider.value);
                        restartSim();
                    }
                }
            }
        }

        ColumnLayout {

            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                id: controlChart
                Layout.fillHeight: true
                Layout.preferredWidth: root.width / 2
                Layout.alignment: Qt.AlignRight
                
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

            ArtificialHorizion {
                visible: true
                Layout.fillHeight: true
                Layout.preferredWidth: root.width / 2

                pitch: flight_sim.pitch
                roll: 0
            }
        }
    }

    PIDTuningGuide {
        id: tuningGuide
    }
}
