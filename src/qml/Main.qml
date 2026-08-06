import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

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

    ColumnLayout {
        anchors.fill: parent

        ComboBox {
            id: presetSelector

            Layout.fillWidth: true

            model: [
                { name: "Start", source: ""},
                { name: "PID Lab", source: "PIDLab.qml" }
            ]

            textRole: "name"

            onActivated: {
                presetLoader.source = currentValue.source
            }
        }

        Loader {
            id: presetLoader
            sourceComponent: FL.PIDLab

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
