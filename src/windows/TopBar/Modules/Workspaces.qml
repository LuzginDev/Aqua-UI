import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Hyprland
import "../../../theme"

RowLayout {
    spacing: 6

    Repeater {
        model: [1, 2, 3, 4, 5, 6] 

        Rectangle {
            id: dot
            property int wsId: modelData
            property bool isActive: Hyprland.activeWorkspace.id === wsId
            property bool isOccupied: {
                for (var i = 0; i < Hyprland.workspaces.length; i++) {
                    if (Hyprland.workspaces[i].id === wsId) return true;
                }
                return false;
            }

            implicitWidth: isActive ? 24 : (isOccupied ? 8 : 6)
            implicitHeight: 6
            radius: 3

            color: isActive ? Colors.textPrimary : (isOccupied ? Colors.textSecondary : Qt.rgba(Colors.textSecondary.r, Colors.textSecondary.g, Colors.textSecondary.b, 0.2))
            
            Behavior on implicitWidth { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
            Behavior on color { ColorAnimation { duration: 200 } }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4 
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace", String(dot.wsId))
            }
        }
    }
}