import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Hyprland
import "../../theme"
import "../../services"
import "./Components"

PanelWindow {
    id: overviewWindow
    anchors.fill: parent
    layer: Layer.Overlay
    color: "transparent"

    visible: opacity > 0
    opacity: ShellState.isOverviewOpen ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    MouseArea {
        anchors.fill: parent
        onClicked: ShellState.toggleOverview()
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    GridView {
        id: grid
        anchors.fill: parent
        anchors.margins: 80
        
        cellWidth: 260
        cellHeight: 200
        
        // Take the list of all Hyprland windows
        model: Hyprland.clients 
        
        delegate: OverviewItem {
            // Show only windows from the current workspace
            property bool isRelevant: Hyprland.activeWorkspace && modelData.workspace.id === Hyprland.activeWorkspace.id
            
            visible: isRelevant
            width: isRelevant ? 240 : 0
            height: isRelevant ? 180 : 0
            
            windowData: modelData
            
            onClicked: {
                Hyprland.dispatch("focuswindow", "address:" + modelData.address)
                ShellState.toggleOverview()
            }
        }

        // Animation when adding windows to the grid
        add: Transition {
            NumberAnimation { properties: "scale"; from: 0.5; to: 1.0; duration: 300; easing.type: Easing.OutBack }
            NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 200 }
        }
    }
}