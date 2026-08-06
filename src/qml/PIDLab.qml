import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import FlightLaboratory as FL

Item {
    anchors.fill: parent

    FL.BasicDynamicsSim {
        id: cosDynamicsSim
    }

    GridLayout {
        anchors.fill: parent

        ArtificialHorizion {
            visible: true
            Layout.fillHeight: true
            Layout.fillWidth: true

            roll: cosDynamicsSim.roll
            pitch: 0
        }
    }
}
