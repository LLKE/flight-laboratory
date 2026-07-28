import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "../FlightLaboratory"
import FlightLaboratory as FL


ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Flight Laboratory")
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"

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
            pitch: -15
        }
    }
}
