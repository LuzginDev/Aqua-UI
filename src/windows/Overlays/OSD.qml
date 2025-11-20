import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../theme"
import "../../components"
import "../../services"

PanelWindow {
    anchors { bottom: true; horizontalCenter: true }
    margins { bottom: 140 }
    width: 160; height: 160
    color: "transparent"; layer: Layer.Overlay
    mask: Region {} 

    opacity: OSDService.activeType !== "" ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }
    visible: opacity > 0

    GlassPanel {
        anchors.fill: parent; radius: 24
        Column {
            anchors.centerIn: parent; spacing: 12
            Image {
                width: 64; height: 64
                source: {
                    if (OSDService.activeType === "volume") return "image://icon/audio-volume-high"
                    if (OSDService.activeType === "brightness") return "image://icon/display-brightness-symbolic"
                    if (OSDService.activeType === "keyboard") return "image://icon/input-keyboard-symbolic"
                    return ""
                }
            }
            Rectangle {
                visible: OSDService.activeType !== "keyboard"
                width: 120; height: 6; radius: 3; color: Qt.rgba(0,0,0,0.2)
                Rectangle {
                    height: parent.height; radius: 3; color: Colors.textPrimary
                    width: parent.width * Math.min(Math.max(OSDService.value, 0), 1)
                    Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCirc } }
                }
            }
            Text {
                visible: OSDService.activeType === "keyboard"
                text: OSDService.layoutText
                font.pixelSize: 24; font.weight: Font.Bold; color: Colors.textPrimary
            }
        }
    }
}