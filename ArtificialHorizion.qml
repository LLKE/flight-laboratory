import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

// TODO: Ensure pitch indicator and roll indicator (pitch ladder) are pixel perfect
// TODO: Understand Canvas

Item {
    id: root
    visible: true

    property real roll: 0.0
    property real pitch: 0.0

    Rectangle {
        id: instrumentDial
        anchors.centerIn: parent
        width: Math.min(root.width, root.height)
        height: width
        radius: width/2

        Canvas {
            id: canvas
            anchors.fill: parent

            Timer {
                interval: 16 // ~60 FPS (1000ms / 60)
                running: true
                repeat: true
                onTriggered: {
                    // Update your angles here if needed, then request a redraw
                    canvas.requestPaint()
                }
            }

            onPaint: {
                var ctx = getContext("2d");
                var bezel_width = 10;
                var bezel_radius = (width / 2);

                ctx.clearRect(0, 0, width, height);

                // Circular viewport
                ctx.save();
                ctx.beginPath();
                ctx.arc(width/2, height/2, width/2, 0, 2*Math.PI);
                ctx.clip();

                // Move origin to centre
                ctx.translate(width/2, height/2);

                ctx.save();

                // Roll
                // ctx.rotate(roll * Math.PI / 180);

                // Pitch
                ctx.translate(0, calcHorizonShift(pitch));

                // Draw sky
                ctx.fillStyle = "#0689e4";
                ctx.fillRect(-width, -height*2, width*2, height*2);

                // Draw ground
                ctx.fillStyle = "#A66b26";
                ctx.fillRect(-width, 0, width*2, height*2);

                ctx.restore()

                // Draw bezel
                ctx.beginPath();
                ctx.arc(0, 0, bezel_radius, 0, 2 * Math.PI, false)

                ctx.lineWidth = bezel_width;
                ctx.strokeStyle = Qt.rgba(1, 2, 3, 4)
                ctx.stroke();

                ctx.restore();
            }
        }
    }

    Shape {
        id: rollIndicator

        width: root.width / 10
        height: root.height / 10

        x: root.width / 2 - rollIndicator.width / 2
        y: 0

        layer.enabled: true
        layer.samples: 4

        // transform: Rotation {
        //     origin.x: rollIndicator.width / 2
        //     origin.y: root.height / 2
        //     angle: roll
        // }

        ShapePath {
            strokeColor: "white"
            strokeWidth: 1
            fillColor: "white"

            startX: rollIndicator.width / 2
            startY: 0

            PathLine { x: rollIndicator.width; y: rollIndicator.height }
            PathLine { x: 0; y: rollIndicator.height }
            PathLine { x: rollIndicator.width / 2; y: 0 }
        }
    }

    Item {
        id: rollTicks

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -parent.height / 2 // tick length

        property variant bankAngles: [-60, -45, -30, -20, -10, 0, 10, 20, 30, 45, 60]

        property real centerX: width / 2
        property real centerY: height / 2

        Repeater {
            model: rollTicks.bankAngles
            delegate: Item {
                id: tickWrapper

                anchors.horizontalCenter: parent.horizontalCenter
                y: 0
                width: 2
                height: root.height / 2

                transform: Rotation {
                    origin.x: tickWrapper.width / 2
                    origin.y: tickWrapper.height
                    angle: modelData
                }

                Rectangle {
                    id: tickLine
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top

                    height: (modelData % 30 === 0) ? 15 : 8
                    width: (modelData % 30 === 0) ? 5 : 1.5
                    color: "#ffffff"
                }
            }
        }
    }

    Item {
        id: pipper
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -pipperRects.width/2

        Row {
            id: pipperRects
            spacing: root.width/18

            Rectangle { width: 2 * root.width/9; height: 5 }
            Rectangle { width: 5; height: 5 }
            Rectangle { width: 2 * root.width/9; height: 5 }
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
                delegate: PitchIndicationComponentPositive{}
            }
        }

        Column {
            id: pitchLadderDown
            spacing: 20

            Repeater {
                model: ["10", "20", "30"]
                delegate: PitchIndicationComponentNegative{}
            }
        }
    }

    component PitchIndicationComponentPositive : Item {

        required property string modelData

        //! Should change with instrument size
        width: 50
        height: 20

        Column {
            id: pitchIndicationLines
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

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
            id: pitchText
            text: modelData
            color: "white"
            anchors.verticalCenter: pitchIndicationLines.top
            anchors.right: pitchIndicationLines.left
            anchors.rightMargin: 10
        }

        Text {
            id: pitchTextLeft
            text: modelData
            color: "white"
            anchors.verticalCenter: pitchIndicationLines.top
            anchors.left: pitchIndicationLines.right
            anchors.leftMargin: 10
        }
    }

    component PitchIndicationComponentNegative : Item {

        required property string modelData
        //! Should change with instrument size
        width: 50
        height: 20

        Column {
            id: pitchIndicationLines
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            // Short tick line
            Rectangle {
                id: shortLine
                width: root.width / 9
                height: 1
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Long main line
            Rectangle {
                id: longLine
                width: 2 * root.width / 9
                height: 1
                color: "white"
            }
        }

        Text {
            id: pitchText
            text: modelData
            color: "white"
            anchors.verticalCenter: pitchIndicationLines.bottom
            anchors.right: pitchIndicationLines.left
            anchors.rightMargin: 10
        }

        Text {
            id: pitchTextLeft
            text: modelData
            color: "white"
            anchors.verticalCenter: pitchIndicationLines.bottom
            anchors.left: pitchIndicationLines.right
            anchors.leftMargin: 10
        }
    }

    function calcHorizonShift (pitch) {
        // 40 pixels = 10 degrees pitch
        return 4 * pitch
    }
}
