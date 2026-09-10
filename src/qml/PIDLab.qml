import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import FlightLaboratory as FL

Item {
    anchors.fill: parent

    FL.FlightSimulation {
        id: flight_sim
    }

    GridLayout {
        anchors.fill: parent

        ArtificialHorizion {
            visible: true
            Layout.fillHeight: true
            Layout.fillWidth: true

            roll: flight_sim.pitch
            pitch: 0
        }
    }
}
