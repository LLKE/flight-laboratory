import QtQuick

import QtQuick.Controls
import QtQuick.Layouts

import "../BasicComponents" as BC

Item {
    id: root

    property real kp: 1.5
    property real ki: 0.05
    property real kd: 0.4

    function showDetails(block) {
        detailsPopup.selectedBlock = block
        detailsPopup.open()
    }

    BC.TitledFrame {
        id: frame

        anchors.fill: parent
        title: "PID Control Loop"

        Item {
            id: diagram

            anchors.fill: parent

            readonly property real signalY: height * 0.44
            readonly property real feedbackY: height * 0.81
            readonly property real outputStartX: plantBlock.x + plantBlock.width
            readonly property real outputEndX: width * 0.98
            readonly property real outputMidX: (outputStartX + outputEndX) / 2

            PIDSignalArrow {
                startX: diagram.width * 0.04
                startY: summingJunction.y + summingJunction.height / 2
                endX: summingJunction.x
                endY: summingJunction.y + summingJunction.height / 2
            }

            PIDSignalArrow {
                startX: summingJunction.x + summingJunction.width
                startY: summingJunction.y + summingJunction.height / 2
                endX: pidBlock.x
                endY: pidBlock.y + pidBlock.height / 2
            }

            PIDSignalArrow {
                startX: pidBlock.x + pidBlock.width
                startY: pidBlock.y + pidBlock.height / 2
                endX: plantBlock.x
                endY: plantBlock.y + plantBlock.height / 2
            }

            PIDSignalArrow {
                startX: diagram.outputStartX
                startY: plantBlock.y + plantBlock.height / 2
                endX: diagram.outputEndX
                endY: diagram.signalY
            }

            PIDSignalArrow {
                startX: diagram.outputMidX
                startY: diagram.signalY
                bend1Enabled: true
                bend1X: diagram.outputMidX
                bend1Y: diagram.feedbackY
                bend2Enabled: true
                bend2X: summingJunction.x + summingJunction.width / 2
                bend2Y: diagram.feedbackY
                endX: summingJunction.x + summingJunction.width / 2
                endY: summingJunction.y + summingJunction.height
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
                y: diagram.signalY - height / 2
                width: Math.min(diagram.width * 0.1, diagram.height * 0.18)
                height: width
                radius: width / 2
                color: "#252A30"
                border.color: "#D6DEE8"
                border.width: 2

                HoverHandler {
                    id: summingJunctionHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: root.showDetails("error")
                }

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
                y: pitchLabel.y
                width: diagram.width * 0.07
                text: "e(t)"
                color: "#D6DEE8"
                font.pixelSize: Math.max(8, Math.min(11, diagram.width / 36))
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: pidBlock

                x: diagram.width * 0.32
                y: diagram.signalY - height / 2
                width: diagram.width * 0.2
                height: diagram.height * 0.22
                radius: 5
                color: "#173D5C"
                border.color: pidBlockHover.hovered ? "#64B5F6" : "#2196F3"
                border.width: 2

                HoverHandler {
                    id: pidBlockHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: root.showDetails("pid")
                }

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
                y: pitchLabel.y
                width: diagram.width * 0.09
                text: "u(t)"
                color: "#D6DEE8"
                font.pixelSize: Math.max(8, Math.min(11, diagram.width / 36))
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                id: plantBlock

                x: diagram.width * 0.65
                y: diagram.signalY - height / 2
                width: diagram.width * 0.2
                height: diagram.height * 0.22
                radius: 5
                color: "#303944"
                border.color: plantBlockHover.hovered ? "#CFD8DC" : "#90A4AE"
                border.width: 2

                HoverHandler {
                    id: plantBlockHover
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: root.showDetails("pitch")
                }

                Text {
                    anchors.fill: parent
                    anchors.margins: 4
                    text: "Aircraft\nPitch Model"
                    color: "#FFFFFF"
                    font.pixelSize: Math.max(8, Math.min(11, plantBlock.width / 8))
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    minimumPixelSize: 6
                    fontSizeMode: Text.Fit
                }
            }

            Text {
                id: pitchLabel

                x: diagram.outputMidX - width / 2
                y: diagram.signalY - height - diagram.height * 0.04
                width: diagram.width * 0.18
                text: "Pitch θ(t)"
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

            Text {
                x: diagram.width * 0.2
                y: diagram.height * 0.94
                width: diagram.width * 0.6
                text: "Click the summing point or either block for details"
                color: "#AEBAC7"
                font.pixelSize: Math.max(8, Math.min(10, diagram.width / 40))
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Popup {
        id: detailsPopup

        property string selectedBlock: "pid"

        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(parent.width - 32, 720)
        height: Math.min(parent.height - 32, 480)
        padding: 16
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#262626"
            border.color: "#666666"
            radius: 4
        }

        contentItem: ColumnLayout {
            spacing: 10

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    text: detailsPopup.selectedBlock === "pid"
                        ? "Inside the PID Controller"
                        : detailsPopup.selectedBlock === "pitch"
                            ? "Inside the Aircraft Pitch Model"
                            : "Error at the Summing Junction"
                    font.pixelSize: 17
                    font.bold: true
                }

                Button {
                    text: "Close"
                    onClicked: detailsPopup.close()
                }
            }

            ScrollView {
                id: detailScroll

                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: availableWidth

                ColumnLayout {
                    width: detailScroll.availableWidth
                    spacing: 12

                    ColumnLayout {
                        visible: detailsPopup.selectedBlock === "error"
                        Layout.fillWidth: true
                        spacing: 12

                        Label {
                            Layout.fillWidth: true
                            text: "The setpoint is compared with the previous pitch measurement:"
                            wrapMode: Text.WordWrap
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 76
                            radius: 6
                            color: "#252A30"
                            border.color: "#D6DEE8"

                            Label {
                                anchors.fill: parent
                                anchors.margins: 12
                                text: "eₖ = rₖ − θₖ₋₁"
                                font.pixelSize: 22
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Label {
                            Layout.fillWidth: true
                            text: "This error is the input to the proportional, integral, and derivative paths."
                            wrapMode: Text.WordWrap
                        }
                    }

                    ColumnLayout {
                        visible: detailsPopup.selectedBlock === "pid"
                        Layout.fillWidth: true
                        spacing: 12

                        Label {
                            Layout.fillWidth: true
                            text: "The error is split into three parallel paths. Their outputs are added to form the control command."
                            wrapMode: Text.WordWrap
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Repeater {
                                model: [
                                    {
                                        name: "Proportional",
                                        gain: "Kp = " + root.kp.toFixed(2),
                                        equation: "Pₖ = Kp · eₖ",
                                        color: "#173D5C",
                                        border: "#2196F3"
                                    },
                                    {
                                        name: "Integral",
                                        gain: "Ki = " + root.ki.toFixed(2),
                                        equation: "Iₖ = Iₖ₋₁ + eₖ · Δt",
                                        color: "#254D3A",
                                        border: "#66BB6A"
                                    },
                                    {
                                        name: "Derivative",
                                        gain: "Kd = " + root.kd.toFixed(2),
                                        equation: "Dₖ = Kd · (eₖ − eₖ₋₁) / Δt",
                                        color: "#59411F",
                                        border: "#FFB74D"
                                    }
                                ]

                                delegate: Rectangle {
                                    required property var modelData

                                    Layout.fillWidth: true
                                    Layout.minimumWidth: 100
                                    Layout.preferredHeight: 132
                                    radius: 6
                                    color: modelData.color
                                    border.color: modelData.border
                                    border.width: 2

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 6

                                        Label {
                                            Layout.fillWidth: true
                                            text: modelData.name
                                            font.bold: true
                                            horizontalAlignment: Text.AlignHCenter
                                        }

                                        Label {
                                            Layout.fillWidth: true
                                            text: modelData.gain
                                            horizontalAlignment: Text.AlignHCenter
                                        }

                                        Label {
                                            Layout.fillWidth: true
                                            text: modelData.equation
                                            wrapMode: Text.WordWrap
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 72
                            radius: 6
                            color: "#252A30"
                            border.color: "#90A4AE"

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 2

                                Label {
                                    Layout.fillWidth: true
                                    text: "Summed controller output"
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Label {
                                    Layout.fillWidth: true
                                    text: "uₖ = Kp · eₖ + Ki · Iₖ + Kd · (eₖ − eₖ₋₁) / Δt"
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        visible: detailsPopup.selectedBlock === "pitch"
                        Layout.fillWidth: true
                        spacing: 12

                        Label {
                            Layout.fillWidth: true
                            text: "The controller output drives the elevator input. The model calculates acceleration, then updates pitch rate and pitch angle in sequence."
                            wrapMode: Text.WordWrap
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 90
                                Layout.preferredHeight: 142
                                radius: 6
                                color: "#252A30"
                                border.color: "#D6DEE8"

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 6

                                    Label {
                                        Layout.fillWidth: true
                                        text: "Elevator input"
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    Label {
                                        Layout.fillWidth: true
                                        text: "δeₖ = uₖ"
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }

                            Label {
                                text: "→"
                                font.pixelSize: 22
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 105
                                Layout.preferredHeight: 142
                                radius: 6
                                color: "#303944"
                                border.color: "#90A4AE"
                                border.width: 2

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 6

                                    Label {
                                        Layout.fillWidth: true
                                        text: "Pitch acceleration"
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    Label {
                                        Layout.fillWidth: true
                                        text: "αₖ = K · δeₖ − D · qₖ₋₁"
                                        wrapMode: Text.WordWrap
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }

                            Label {
                                text: "→"
                                font.pixelSize: 22
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 105
                                Layout.preferredHeight: 142
                                radius: 6
                                color: "#303944"
                                border.color: "#90A4AE"
                                border.width: 2

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 6

                                    Label {
                                        Layout.fillWidth: true
                                        text: "Pitch rate"
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    Label {
                                        Layout.fillWidth: true
                                        text: "qₖ = qₖ₋₁ + αₖ · Δt"
                                        wrapMode: Text.WordWrap
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }

                            Label {
                                text: "→"
                                font.pixelSize: 22
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 105
                                Layout.preferredHeight: 142
                                radius: 6
                                color: "#303944"
                                border.color: "#90A4AE"
                                border.width: 2

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 6

                                    Label {
                                        Layout.fillWidth: true
                                        text: "Pitch angle"
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                    Label {
                                        Layout.fillWidth: true
                                        text: "θₖ = θₖ₋₁ + qₖ · Δt"
                                        wrapMode: Text.WordWrap
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }

                        Label {
                            Layout.fillWidth: true
                            text: "The angle update uses the newly calculated pitch rate (semi-implicit Euler integration)."
                            wrapMode: Text.WordWrap
                            color: "#AEBAC7"
                        }
                    }
                }
            }
        }
    }
}