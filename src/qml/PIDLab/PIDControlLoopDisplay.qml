import QtQuick

import "../BasicComponents" as BC

Item {
    id: root

    property real kp: 1.5
    property real ki: 0.05
    property real kd: 0.4

    BC.TitledFrame {
        id: frame

        anchors.fill: parent
        title: "PID Control Loop"

        Item {
            id: diagram

            anchors.fill: parent

            PIDSignalArrow {
                startX: diagram.width * 0.04
                startY: diagram.height * 0.44
                endX: diagram.width * 0.14
                endY: diagram.height * 0.44
            }

            PIDSignalArrow {
                startX: diagram.width * 0.24
                startY: diagram.height * 0.44
                endX: diagram.width * 0.32
                endY: diagram.height * 0.44
            }

            PIDSignalArrow {
                startX: diagram.width * 0.56
                startY: diagram.height * 0.44
                endX: diagram.width * 0.65
                endY: diagram.height * 0.44
            }

            PIDSignalArrow {
                startX: diagram.width * 0.89
                startY: diagram.height * 0.44
                endX: diagram.width * 0.96
                endY: diagram.height * 0.44
            }

            PIDSignalArrow {
                startX: diagram.width * 0.96
                startY: diagram.height * 0.44
                bend1Enabled: true
                bend1X: diagram.width * 0.96
                bend1Y: diagram.height * 0.81
                bend2Enabled: true
                bend2X: diagram.width * 0.19
                bend2Y: diagram.height * 0.81
                endX: diagram.width * 0.19
                endY: diagram.height * 0.54
            }

            Text {
                x: diagram.width * 0.03
                y: diagram.height * 0.32
                width: diagram.width * 0.12
                text: "Setpoint\nr(t)"
                color: "#D6DEE8"
                font.pixelSize: Math.max(9, Math.min(12, diagram.width / 32))
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: summingJunction

                x: diagram.width * 0.19 - width / 2
                y: diagram.height * 0.44 - height / 2
                width: Math.min(diagram.width * 0.1, diagram.height * 0.18)
                height: width
                radius: width / 2
                color: "#252A30"
                border.color: "#D6DEE8"
                border.width: 2

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: parent.height * 0.12
                    text: "+"
                    color: "#FFFFFF"
                    font.pixelSize: Math.max(10, parent.width * 0.34)
                    font.bold: true
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: parent.height * 0.52
                    text: "−"
                    color: "#FFFFFF"
                    font.pixelSize: Math.max(10, parent.width * 0.34)
                    font.bold: true
                }
            }

            Text {
                x: diagram.width * 0.245
                y: diagram.height * 0.32
                width: diagram.width * 0.07
                text: "e(t)"
                color: "#D6DEE8"
                font.pixelSize: Math.max(8, Math.min(11, diagram.width / 36))
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: pidBlock

                x: diagram.width * 0.32
                y: diagram.height * 0.30
                width: diagram.width * 0.24
                height: diagram.height * 0.28
                radius: 5
                color: "#173D5C"
                border.color: "#2196F3"
                border.width: 2

                Text {
                    anchors.fill: parent
                    anchors.margins: 3
                    text: "PID Controller\nKp: " + root.kp.toFixed(2)
                        + "\nKi: " + root.ki.toFixed(2)
                        + "\nKd: " + root.kd.toFixed(2)
                    color: "#FFFFFF"
                    font.pixelSize: Math.max(8, Math.min(11, pidBlock.width / 9))
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    minimumPixelSize: 7
                    fontSizeMode: Text.Fit
                }
            }

            Text {
                x: diagram.width * 0.56
                y: diagram.height * 0.32
                width: diagram.width * 0.09
                text: "u(t)"
                color: "#D6DEE8"
                font.pixelSize: Math.max(8, Math.min(11, diagram.width / 36))
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: plantBlock

                x: diagram.width * 0.65
                y: diagram.height * 0.30
                width: diagram.width * 0.24
                height: diagram.height * 0.28
                radius: 5
                color: "#303944"
                border.color: "#90A4AE"
                border.width: 2

                Text {
                    anchors.fill: parent
                    anchors.margins: 4
                    text: "Aircraft Pitch\nModel"
                    color: "#FFFFFF"
                    font.pixelSize: Math.max(9, Math.min(12, plantBlock.width / 8))
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }
            }

            Text {
                x: diagram.width * 0.89
                y: diagram.height * 0.30
                width: diagram.width * 0.11
                text: "Pitch\nθ(t)"
                color: "#D6DEE8"
                font.pixelSize: Math.max(8, Math.min(11, diagram.width / 36))
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                x: diagram.width * 0.42
                y: diagram.height * 0.83
                width: diagram.width * 0.25
                text: "Negative feedback"
                color: "#AEBAC7"
                font.pixelSize: Math.max(8, Math.min(11, diagram.width / 36))
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}