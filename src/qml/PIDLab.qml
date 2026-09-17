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
    }

    RowLayout {
        anchors.fill: parent

        Item {
            id: controlChart
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ChartView {
                id: chart
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
