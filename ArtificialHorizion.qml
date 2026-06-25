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
        transform {
            Rotation { origin.x: root.width/2; origin.y: root.height/2; angle: roll }
            Translate { y: y + calcHorizonShift(pitch) }
        }
    }

    Item {
        id: pipper
        anchors.verticalCenter: root.verticalCenter
        x: 2 * root.width/9

        RowLayout {
            spacing: root.width/18 - 2.5

            Rectangle { width: 2 * root.width/9; height: 5 }
            Rectangle { width: 5; height: 5 }
            Rectangle { width: 2* root.width/9; height: 5 }
        }
    }

    Column {
        id: pitchLadder

        spacing: 40
        anchors.horizontalCenter: root.horizontalCenter
        anchors.verticalCenter: root.verticalCenter

        Column {
            id: pitchLadderUp
            spacing: 20

            Repeater {
                model: ["30", "20", "10"]
                delegate: PitchIndicationComponent { isNegative: false }
            }
        }

        Column {
            id: pitchLadderDown
            spacing: 20

            Repeater {
                model: ["10", "20", "30"]
                delegate: PitchIndicationComponent { isNegative: true }
            }
        }
    }

    component PitchIndicationComponent : Item {

        required property bool isNegative
        required property string modelData

        width: pitchIndicationLines.implicitWidth
        height: pitchIndicationLines.implicitHeight

        Column {
            id: pitchIndicationLines
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            move: Transition { NumberAnimation { properties: "y"; duration: 0 } }

            // Long main line
            Rectangle {
                id: longLine
                width: 2 * root.width / 9
                height: 1
                color: "white"
            }

            // Short tick line
            Rectangle {
                id: shortLine
                width: root.width / 9
                height: 1
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Text {
            text: isNegative ? "-" + modelData : modelData
            color: "white"
            anchors.verticalCenter: isNegative ? pitchIndicationLines.bottom : pitchIndicationLines.top
            anchors.right: pitchIndicationLines.left
            anchors.rightMargin: 10
        }

        Text {
            text: isNegative ? "-" + modelData : modelData
            color: "white"
            anchors.verticalCenter: isNegative ? pitchIndicationLines.bottom : pitchIndicationLines.top
            anchors.left: pitchIndicationLines.right
            anchors.leftMargin: 10
        }

        states: [
            State {
                name: "negative"
                when: isNegative

                PropertyChanges {
                    target: pitchIndicationLines
                    data: [shortLine, longLine]
                }
            }
        ]
    }

    function calcHorizonShift (pitch) {
        // 40 pixels = 10 degrees pitch
        return pitchLadder.spacing * pitch
    }
}
