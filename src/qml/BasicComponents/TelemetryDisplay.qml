import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Frame {
    id: root

    property string title: "Telemetry"
    property real value: 0
    property string unit: ""
    property int decimals: 1

    implicitWidth: 180
    implicitHeight: 110
    padding: 12

    ColumnLayout {
        anchors.fill: parent
        spacing: 6

        Label {
            text: root.title
            color: palette.mid
            font.bold: true
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            Label {
                text: root.value.toFixed(root.decimals)
                font.pixelSize: 32
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                text: root.unit
                color: palette.mid
                font.pixelSize: 16
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
