// Theme.qml
pragma Singleton
import QtQuick

QtObject {
    // Colors
    readonly property color primaryColor: "#2196F3"
    readonly property color backgroundColor: "#272727"
    readonly property color textColor: "#FFFFFF"
    
    // Typography
    readonly property string fontFamily: "Roboto"
    readonly property int fontSizeBody: 14
    readonly property int fontSizeHeader: 24
    
    // Layout & Spacing
    readonly property int marginMedium: 16
    readonly property int borderRadius: 8
}
