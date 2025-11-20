import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../theme"

PanelWindow {
    anchors { top: true; left: true; right: true }
    height: Metrics.topBarHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Normal
    layer: Layer.Top

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width; height: Metrics.borderWidth
            color: Colors.border
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Metrics.padding; anchors.rightMargin: Metrics.padding
        LeftArea { Layout.fillHeight: true }
        Item { Layout.fillWidth: true }
        RightArea { Layout.fillHeight: true }
    }
}