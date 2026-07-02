import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: root
    visible: true
    width: 300
    height: 300

    property real roll: 0.0
    property real pitch: 0.0

    Rectangle {
        id: instrumentDial
        anchors.fill: parent
        radius: width/2

        Canvas {
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");

                ctx.clearRect(0, 0, width, height);

                // Circular viewport
                ctx.save();
                ctx.beginPath();
                ctx.arc(width/2, height/2, width/2, 0, 2*Math.PI);
                ctx.clip();

                // Move origin to centre
                ctx.translate(width/2, height/2);

                // Roll
                ctx.rotate(roll * Math.PI / 180);

                // Pitch
                ctx.translate(0, pitch * 4);

                // Draw sky
                ctx.fillStyle = "#0689e4";
                ctx.fillRect(-width, -height*2, width*2, height*2);

                // Draw ground
                ctx.fillStyle = "#A66b26";
                ctx.fillRect(-width, 0, width*2, height*2);

                ctx.restore();
            }
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
        return 4 * pitch
    }
}
