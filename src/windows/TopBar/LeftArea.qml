import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Hyprland
import "../../theme"
import "../../components"
import "../../services"
import "./Modules"

RowLayout {
    spacing: Metrics.padding

    AquaButton {
        id: logoBtn
        iconSource: "image://icon/archlinux-logo" 
        horizontalPadding: 8
        color: ShellState.isAppLauncherOpen ? Colors.selection : (containsMouse ? Colors.selection : "transparent")
        onClicked: ShellState.toggleAppLauncher()
    }
    
    Rectangle {
        Layout.preferredWidth: 1; Layout.preferredHeight: 14
        color: Colors.border
    }

    Workspaces {
        Layout.alignment: Qt.AlignVCenter
    }

    Rectangle {
        Layout.preferredWidth: 1; Layout.preferredHeight: 14
        color: Colors.border
    }

    Text {
        property var activeWin: Hyprland.activeWindow
        text: (activeWin.address !== "") ? activeWin.title : "Desktop"
        
        font.pixelSize: Metrics.fontSizeBody
        font.weight: Font.Bold
        color: Colors.textPrimary
        
        Layout.maximumWidth: 300
        elide: Text.ElideRight
        Layout.leftMargin: 4
    }
}