import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property real startX: 0
    property real startY: 0
    property real endX: 0
    property real endY: 0
    property bool bend1Enabled: false
    property real bend1X: 0
    property real bend1Y: 0
    property bool bend2Enabled: false
    property real bend2X: 0
    property real bend2Y: 0
    property color color: "#D6DEE8"
    property real lineWidth: 2
    property real headLength: 8
    property real headHalfWidth: 4

    readonly property real lastSegmentStartX: bend2Enabled
        ? bend2X : bend1Enabled ? bend1X : startX
    readonly property real lastSegmentStartY: bend2Enabled
        ? bend2Y : bend1Enabled ? bend1Y : startY
    readonly property real directionX: endX - lastSegmentStartX
    readonly property real directionY: endY - lastSegmentStartY
    readonly property real directionLength: Math.max(
        Math.sqrt(directionX * directionX + directionY * directionY), 0.001)
    readonly property real unitX: directionX / directionLength
    readonly property real unitY: directionY / directionLength
    readonly property real perpendicularX: -unitY
    readonly property real perpendicularY: unitX
    readonly property real headBaseX: endX - unitX * headLength
    readonly property real headBaseY: endY - unitY * headLength

    anchors.fill: parent

    Shape {
        anchors.fill: parent

        ShapePath {
            strokeColor: root.color
            strokeWidth: root.lineWidth
            fillColor: "transparent"
            startX: root.startX
            startY: root.startY
            PathLine {
                x: root.bend1Enabled ? root.bend1X : root.endX
                y: root.bend1Enabled ? root.bend1Y : root.endY
            }
            PathLine {
                x: root.bend2Enabled ? root.bend2X : root.endX
                y: root.bend2Enabled ? root.bend2Y : root.endY
            }
            PathLine { x: root.endX; y: root.endY }
        }

        ShapePath {
            strokeColor: root.color
            strokeWidth: root.lineWidth
            fillColor: root.color
            startX: root.headBaseX + root.perpendicularX * root.headHalfWidth
            startY: root.headBaseY + root.perpendicularY * root.headHalfWidth
            PathLine { x: root.endX; y: root.endY }
            PathLine {
                x: root.headBaseX - root.perpendicularX * root.headHalfWidth
                y: root.headBaseY - root.perpendicularY * root.headHalfWidth
            }
            PathLine {
                x: root.headBaseX + root.perpendicularX * root.headHalfWidth
                y: root.headBaseY + root.perpendicularY * root.headHalfWidth
            }
        }
    }
}
