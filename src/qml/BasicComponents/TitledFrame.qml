import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Frame {
    id: root

    property string title: ""
    default property alias content: contentContainer.data

    padding: 12

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Label {
            text: root.title
            color: palette.text
            font.pixelSize: 15
            font.bold: true
            Layout.fillWidth: true
        }

        Rectangle {
            color: palette.mid
            opacity: 0.5
            implicitHeight: 1
            Layout.fillWidth: true
        }

        Item {
            id: contentContainer

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
