import QtQuick
import "../../../theme"
Rectangle {
    default property alias content: container.data
    color: Colors.isDark ? Qt.rgba(0,0,0, 0.2) : Qt.rgba(1,1,1, 0.5)
    radius: Metrics.windowRadius
    clip: true
    Item { id: container; anchors.fill: parent; anchors.margins: Metrics.padding }
}