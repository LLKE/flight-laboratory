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
    property bool attitudeValid: isFinite(roll)
        && isFinite(pitch)
        && pitch >= -90
        && pitch <= 90

    Rectangle {

        id: instrumentDial

        anchors.centerIn: parent

        width: Math.min(root.width, root.height) - 40
        height: width
        radius: width/2

        property real pixelsPerDegree: radius / 40

        // Pitch ladder
        property real pitchMarkSpacing: pixelsPerDegree * 5
        property real pitchLadderWidth: width / 3

        // Pitch indication lines
        property real longLineWidth: width * 2 / 9
        property real shortLineWidth: width / 9
        property real lineThickness: Math.max(1, width / 300)

        // Pitch labels
        property real pitchLabelMargin: width / 30
        property real pitchLabelFontSize: width / 25

        Item {
            id: attitudeSource

            width: instrumentDial.width * 4
            height: instrumentDial.height * 4
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
                        angle: -normalizeRoll(roll)
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

                    property real indicationUnitSpacing: instrumentDial.pitchMarkSpacing

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

        Loader {
            id: failureOverlayLoader
            sourceComponent: failureOverlay
            active: !root.attitudeValid
            width: instrumentDial.width
            height: instrumentDial.width
            anchors.centerIn: parent
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

        Shape {
            id: bezel
            anchors.fill: parent

            ShapePath {
                strokeColor: "white"
                strokeWidth: 5
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
    }

    Shape {
        id: rollIndicator

        width: instrumentDial.width * 0.045
        height: instrumentDial.height * 0.035

        anchors {
            top: instrumentDial.top
            horizontalCenter: instrumentDial.horizontalCenter
        }

        layer.enabled: true
        layer.samples: 4

        transform: Rotation {
            origin.x: rollIndicator.width / 2
            origin.y: instrumentDial.height / 2
            angle: -normalizeRoll(roll)
        }

        ShapePath {
            strokeColor: "#252525"
            strokeWidth: 1
            fillColor: "#FFD54A"

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

                    height: (modelData % 30 === 0) ? 12 : 7
                    width: (modelData % 30 === 0) ? 2 : 1
                    color: "#E6EAF0"
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

            Rectangle { width: 2 * instrumentDial.width/9; height: 5; color: "#FFD54A"; border.width: 1; border.color: "#252525" }
            Rectangle { width: 5; height: 5; color: "#FFD54A"; border.width: 1; border.color: "#252525" }
            Rectangle { width: 2 * instrumentDial.width/9; height: 5; color: "#FFD54A"; border.width: 1; border.color: "#252525" }
        }
    }

    component PitchIndicationComponentPositive : Item {

        required property string modelData

        width: instrumentDial.pitchLadderWidth
        height: pitchLadder.indicationUnitSpacing

        Column {
            id: pitchIndicationLines
            spacing: pitchLadder.indicationUnitSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            // Long main line
            Rectangle {
                width: instrumentDial.longLineWidth
                height: instrumentDial.lineThickness
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Short tick line
            Rectangle {
                width: instrumentDial.shortLineWidth
                height: instrumentDial.lineThickness
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
            anchors.rightMargin: instrumentDial.pitchLabelMargin
        }

        Text {
            id: pitchTextLeft
            text: modelData
            color: "white"
            anchors.verticalCenter: pitchIndicationLines.top
            anchors.left: pitchIndicationLines.right
            anchors.leftMargin: instrumentDial.pitchLabelMargin
        }
    }

    component PitchIndicationComponentNegative : Item {

        required property string modelData

        width: instrumentDial.pitchLadderWidth
        height: pitchLadder.indicationUnitSpacing

        Column {
            id: pitchIndicationLines
            spacing: pitchLadder.indicationUnitSpacing
            anchors.horizontalCenter: parent.horizontalCenter

            // Short tick line
            Rectangle {
                width: instrumentDial.shortLineWidth
                height: instrumentDial.lineThickness
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
           
            // Long main line
            Rectangle {
                width: instrumentDial.longLineWidth
                height: instrumentDial.lineThickness
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Text {
            id: pitchText
            text: modelData
            color: "white"
            anchors.verticalCenter: pitchIndicationLines.bottom
            anchors.right: pitchIndicationLines.left
            anchors.rightMargin: instrumentDial.pitchLabelMargin
        }

        Text {
            id: pitchTextLeft
            text: modelData
            color: "white"
            anchors.verticalCenter: pitchIndicationLines.bottom
            anchors.left: pitchIndicationLines.right
            anchors.leftMargin: instrumentDial.pitchLabelMargin
        }
    }

    Component {
        id: failureOverlay

        Item {
            layer.enabled: true

            property var crossThickness: 5

            Rectangle {
                anchors.fill: parent
                color: "black"
            }

            Rectangle {
                width: instrumentDial.width
                height: crossThickness
                anchors.centerIn: parent
                rotation: 45
                color: "red"
            }

            Rectangle {
                width: instrumentDial.width
                height: crossThickness
                anchors.centerIn: parent
                rotation: -45
                color: "red"
            }

            Text {
                color: "red"
                text: "ATTITUDE\nINVALID"
                font.pixelSize: instrumentDial.width / 16
                anchors.centerIn: parent
                anchors.verticalCenterOffset: instrumentDial.width / 4
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    function calcHorizonShift (pitch) {
        // pitchLadder.indicationUnitSpacing = 5 degrees pitch (1 pitch line)

        return instrumentDial.pixelsPerDegree * pitch
    }

    function normalizeRoll(angle) {
        return ((angle + 180) % 360 + 360) % 360 - 180
    }
}
