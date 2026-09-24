import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import QtCharts

import FlightLaboratory as FL

Item {
    anchors.fill: parent

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
            timeTracker.simTime += flight_sim.dt
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

        Item {
            id: controlChart
            Layout.fillWidth: true
            Layout.fillHeight: true
            
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
            Layout.fillWidth: true

            pitch: flight_sim.pitch
            roll: 0
        }
    }
}
