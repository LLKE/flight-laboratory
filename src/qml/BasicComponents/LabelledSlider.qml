import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string title: "Setting"
    property string unit: ""
    property int decimals: 1
    property alias value: slider.value
    property alias from: slider.from
    property alias to: slider.to
    property alias stepSize: slider.stepSize

    spacing: 4

    RowLayout {
        Layout.fillWidth: true

        Label {
            text: root.title
            font.bold: true
            Layout.fillWidth: true // Pushes the value label to the right edge
        }

        Label {
            text: root.value.toFixed(root.decimals) + root.unit
            color: palette.mid
        }
    }

    // The actual slider control
    Slider {
        id: slider
        Layout.fillWidth: true
    }
}
