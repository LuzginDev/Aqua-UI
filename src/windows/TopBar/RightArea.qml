import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Services.Hyprland
import "../../theme"
import "../../components"
import "../../services"
import "./Modules"

RowLayout {
    spacing: 4

    MediaWidget {
        Layout.rightMargin: 8
    }

    Repeater {
        model: SystemTray.items
        AquaButton {
            iconSource: modelData.icon
            horizontalPadding: 4
            onClicked: modelData.activate(Qt.LeftButton)
        }
    }

    AquaButton {
        text: OSDService.currentLayout
        onClicked: Hyprland.dispatch("exec", "sh -c '$HOME/.config/AquaUI/Quickshell/scripts/keyboard.sh'")
    }

    AquaButton {
        text: "CC"
        color: ShellState.isControlCenterOpen ? Colors.selection : (hoverHandler.hovered ? Colors.selection : "transparent")
        onClicked: ShellState.toggleControlCenter()
        property alias hoverHandler: mouseArea 
        MouseArea { id: mouseArea; anchors.fill: parent; hoverEnabled: true; onClicked: parent.clicked() }
    }

    AquaButton {
        content: ClockLabel { anchors.centerIn: parent }
        implicitWidth: contentItem.implicitWidth + 16
        onClicked: console.log("Open Calendar")
    }
}