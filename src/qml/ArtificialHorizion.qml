import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

// TODO: Ensure pitch indicator and roll indicator (pitch ladder) are pixel perfect
// TODO: Understand Canvas

Item {
    id: root
    visible: true

    /**
    * Artificial horizon attitude convention:
    *
    * roll:
    *   Degrees.
    *   Positive = right wing down.
    *
    * pitch:
    *   Degrees.
    *   Positive = nose up.
    *
    * Display convention:
    *   The aircraft reference remains fixed.
    *   The attitude background moves relative to it.
    */

    property real roll: 0.0
    property real pitch: 0.0

    Rectangle {

        id: instrumentDial

        anchors.centerIn: parent

        width: Math.min(root.width, root.height) - 40
        height: width
        radius: width/2

        Shape {
            id: bezel
            anchors.fill: parent

            ShapePath {
                strokeColor: "white"
                strokeWidth: 10
                fillColor: "transparent"

                PathAngleArc {
                    centerX: instrumentDial.width / 2
                    centerY: instrumentDial.height / 2
                    radiusX: instrumentDial.width / 2
                    radiusY: instrumentDial.height / 2
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        }

        Item {
            id: attitudeSource

            width: instrumentDial.width * 3
            height: instrumentDial.height * 3
            anchors.centerIn: parent

            // This item is rendered by MultiEffect instead.
            visible: false

            layer.enabled: true

            Item {
                id: attitudeLayer

                anchors.fill: parent

                transform: [
                    Translate {
                        y: calcHorizonShift(pitch)
                    },
                    Rotation {
                        angle: -roll
                        origin.x: attitudeLayer.width / 2
                        origin.y: attitudeLayer.height / 2
                    }
                ]

                Canvas {
                    id: canvas
                    anchors.fill: parent

                    onPaint: {
                        var ctx = getContext("2d");

                        ctx.clearRect(0, 0, canvas.width, canvas.height);

                        // Move origin to centre
                        ctx.translate(canvas.width/2, canvas.height/2);

                        ctx.save();

                        // Draw sky
                        ctx.fillStyle = "#0689e4";
                        ctx.fillRect(-canvas.width, -canvas.height*2, canvas.width*2, canvas.height*2);

                        // Draw ground
                        ctx.fillStyle = "#A66b26";
                        ctx.fillRect(-canvas.width, 0, canvas.width*2, canvas.height*2);

                        ctx.restore();
                    }
                }

                Column {
                    id: pitchLadder

                    property real indicationUnitSpacing: instrumentDial.radius / 8

                    spacing: 2 * indicationUnitSpacing
                    
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    Column {
                        id: pitchLadderUp
                        spacing: pitchLadder.indicationUnitSpacing

                        Repeater {
                            model: ["30", "20", "10"]
                            delegate: PitchIndicationComponentPositive{}
                        }
                    }

                    Column {
                        id: pitchLadderDown
                        spacing: pitchLadder.indicationUnitSpacing

                        Repeater {
                            model: ["10", "20", "30"]
                            delegate: PitchIndicationComponentNegative{}
                        }
                    }
                }
            }
        }

        // Shows the attitudeSource item through a circular viewport
        MultiEffect {
            id: attitudeEffect

            source: attitudeSource

            width: attitudeSource.width
            height: attitudeSource.height
            anchors.centerIn: parent

            maskEnabled: true
            maskSource: circularMask
        }

        Item {
            id: circularMask

            width: attitudeSource.width
            height: attitudeSource.height
            anchors.centerIn: parent
            visible: false

            layer.enabled: true

            Rectangle {
                width: instrumentDial.width
                height: instrumentDial.height
                radius: width / 2
                anchors.centerIn: parent
                color: "white"
            }
        }
    }

    Shape {
        id: rollIndicator

        width: instrumentDial.width / 14
        height: instrumentDial.height / 14

        anchors {
            top: instrumentDial.top
            horizontalCenter: instrumentDial.horizontalCenter
        }

        layer.enabled: true
        layer.samples: 4

        transform: Rotation {
            origin.x: rollIndicator.width / 2
            origin.y: instrumentDial.height / 2
            angle: -roll
        }

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
        anchors.verticalCenterOffset: -instrumentDial.height / 2

        property variant bankAngles: [-60, -45, -30, -20, -10, 0, 10, 20, 30, 45, 60]

        property real centerX: instrumentDial.width / 2
        property real centerY: instrumentDial.height / 2

        Repeater {
            model: rollTicks.bankAngles
            delegate: Item {
                id: tickWrapper

                anchors.horizontalCenter: parent.horizontalCenter
                y: 0
                width: 2
                height: instrumentDial.height / 2

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
        anchors.verticalCenterOffset: -pipperRects.height/2

        Row {
            id: pipperRects
            spacing: instrumentDial.width/18

            Rectangle { width: 2 * instrumentDial.width/9; height: 5 }
            Rectangle { width: 5; height: 5 }
            Rectangle { width: 2 * instrumentDial.width/9; height: 5 }
        }
    }

    component PitchIndicationComponentPositive : Item {

        required property string modelData

        //! Should change with instrument size
        width: instrumentDial.width / 3
        height: pitchLadder.indicationUnitSpacing

        Column {
            id: pitchIndicationLines
            spacing: pitchLadder.indicationUnitSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            // Long main line
            Rectangle {
                id: longLine
                width: 2 * instrumentDial.width / 9
                height: 1
                color: "white"
            }

            // Short tick line
            Rectangle {
                id: shortLine
                width: instrumentDial.width / 9
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
        width: instrumentDial.width / 3
        height: pitchLadder.indicationUnitSpacing

        Column {
            id: pitchIndicationLines
            spacing: pitchLadder.indicationUnitSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            // Short tick line
            Rectangle {
                id: shortLine
                width: instrumentDial.width / 9
                height: 1
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Long main line
            Rectangle {
                id: longLine
                width: 2 * instrumentDial.width / 9
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
        // pitchLadder.indicationUnitSpacing = 5 degrees pitch (1 pitch line)

        return pitchLadder.indicationUnitSpacing * pitch / 5
    }
}
