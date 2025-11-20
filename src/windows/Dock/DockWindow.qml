import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../theme"
import "../../components"

PanelWindow {
    anchors { bottom: true; horizontalCenter: true }
    margins { bottom: 10 }
    exclusionMode: ExclusionMode.Normal
    layer: Layer.Overlay
    color: "transparent"
    width: container.width; height: container.height

    GlassPanel {
        id: container
        height: Metrics.dockSize + (Metrics.dockPadding * 2)
        width: itemsRow.width + (Metrics.dockPadding * 2)
        radius: Metrics.dockRadius

        property real mouseXPos: -1
        property bool isHovered: hoverMouse.containsMouse

        MouseArea {
            id: hoverMouse; anchors.fill: parent; hoverEnabled: true
            propagateComposedEvents: true
            onPressed: (mouse) => mouse.accepted = false
            onPositionChanged: (mouse) => container.mouseXPos = mouse.x
            onExited: container.mouseXPos = -1
        }

        RowLayout {
            id: itemsRow; anchors.centerIn: parent; spacing: Metrics.dockSpacing
            alignment: Qt.AlignBottom

            DockItem {
                appName: "Terminal"; iconSource: "image://icon/utilities-terminal"
                isRunning: true
                dockMouseX: container.mouseXPos; dockHovered: container.isHovered
                onClicked: console.log("Exec Term")
            }
             DockItem {
                appName: "Browser"; iconSource: "image://icon/firefox"
                dockMouseX: container.mouseXPos; dockHovered: container.isHovered
                onClicked: console.log("Exec Browser")
            }
        }
    }
}