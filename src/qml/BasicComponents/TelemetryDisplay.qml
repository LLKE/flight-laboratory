import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Frame {
    id: root

    property string title: "Telemetry"
    property real value: 0
    property string unit: ""
    property int decimals: 1

    Layout.minimumWidth: 0
    implicitWidth: 150
    implicitHeight: contentLayout.implicitHeight + topPadding + bottomPadding
    padding: 12

    ColumnLayout {
        id: contentLayout

        anchors.fill: parent
        spacing: 6

        Label {
            text: root.title
            color: palette.mid
            font.bold: true
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            wrapMode: Text.WordWrap
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 0
            spacing: 6

            Label {
                text: root.value.toFixed(root.decimals)
                font.pixelSize: 32
                font.bold: true
                fontSizeMode: Text.Fit
                minimumPixelSize: 14
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                elide: Text.ElideRight
            }

            Label {
                text: root.unit
                color: palette.mid
                font.pixelSize: 16
                fontSizeMode: Text.Fit
                minimumPixelSize: 10
                Layout.alignment: Qt.AlignVCenter
                Layout.minimumWidth: 0
                elide: Text.ElideRight
            }
        }
    }
}
