import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Controls
import QtQuick.Window

import FlightLaboratory as FL

ApplicationWindow {
    id: appWindow
    visibility: Window.Maximized
    visible: true
    title: qsTr("Flight Laboratory")

    width: 1920
    height: 1080

    color: FL.Styling.backgroundColor

    ColumnLayout {
        anchors.fill: parent

        ComboBox {
            id: presetSelector

            Layout.fillWidth: true

            model: [
                { name: "Start", source: ""},
                { name: "PID Lab", source: "./PIDLab/PIDLab.qml" }
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
