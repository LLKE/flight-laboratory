import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Popup {
    parent: Overlay.overlay
    anchors.centerIn: parent
    width: Math.min(parent.width - 24, 420)
    height: Math.min(parent.height - 24, 560)
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

        Label {
            text: "Closed-loop PID tuning"
            font.pixelSize: 17
            font.bold: true
            Layout.fillWidth: true
        }

        ScrollView {
            id: guideScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: availableWidth

            Text {
                width: guideScroll.availableWidth
                wrapMode: Text.WordWrap
                color: "white"
                textFormat: Text.MarkdownText
                text: "**1. Find a good P response**\n\nSet `I = 0` and `D = 0`. Start `P` around `0.3` to `0.5`. Click **Rerun**. Orange is the target pitch step (`0°` to `30°`); green is the simulated pitch. Raise `P` in small increments, rerunning after each change. Choose a value that tracks quickly without too much overshoot or ringing. Each run uses the same target step, so compare responses directly.\n\n**2. Reduce overshoot with D**\n\nOnce the P response is satisfactory, try very small increases to `D`, rerunning each time. D can reduce overshoot and ringing. Because this controller differentiates the error and the target jumps at the start, too much `D` can create a sharp initial kick. Keep it low and reduce it if the green trace spikes at the start or the response worsens.\n\n**3. Add I only if needed**\n\nIf the green pitch settles short of the orange target, increase `I` slightly and rerun. I accumulates error to remove that offset, but too much can cause overshoot and continued ringing. This simulation's P control can usually reach the fixed target without I, so leave `I = 0` when no steady offset is visible."
            }
        }

        Button {
            text: "Close"
            Layout.alignment: Qt.AlignRight
            onClicked: close()
        }
    }
}