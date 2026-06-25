import QtQuick
import QtQuick.Layouts

Item {
    id: root
    visible: true
    width: 640
    height: 480

    property real roll: 0.0
    property real pitch: 0.0

    Column {
        id: horizon
        spacing: 2

        Rectangle { id: sky; color: "#0689e4"; width: root.width; height: root.height/2}
        Rectangle { id: ground; color: "#A66b26"; width: root.width; height: root.height/2 }
        transform: Rotation { origin.x: root.width/2; origin.y: root.height/2; angle: roll }
    }

    Item {
        id: pipper
        anchors {
            verticalCenter: root.verticalCenter
        }
        x: 2 * root.width/9

        RowLayout {
            spacing: root.width/9

            Rectangle {

                width: 2 * root.width/9
                height: 3
            }

            Rectangle {

                width: 2* root.width/9
                height: 3
            }
        }
    }

    Item {
        id: pitchIndicationUnit

        property real angleIndication

        width: root.width
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter
        anchors.verticalCenterOffset: -55

        ColumnLayout {
            spacing: 10
            anchors.fill: parent

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                id: markedIndicationLine
                spacing: 20
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: pitchIndicationUnit.angleIndication
                    color: "white"
                }

                Rectangle {
                    width: 2 * root.width/9
                    height: 1
                    color: "white"
                }

                Text {
                    text: pitchIndicationUnit.angleIndication
                    color: "white"
                }
            }

            Rectangle {
                Layout.preferredWidth: root.width/9
                height: 1
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
