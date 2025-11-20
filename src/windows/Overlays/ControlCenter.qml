import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../theme"
import "../../components"
import "../../services"
import "./Components"

PanelWindow {
    anchors { top: true; right: true }
    margins { top: Metrics.topBarHeight + 10; right: 10 }
    width: 320; height: 300
    color: "transparent"
    layer: Layer.Overlay
    
    opacity: ShellState.isControlCenterOpen ? 1 : 0
    visible: opacity > 0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    GlassPanel {
        anchors.fill: parent
        transform: Translate {
            y: ShellState.isControlCenterOpen ? 0 : -30
            Behavior on y { NumberAnimation { duration: 300; easing.type: Animations.popUpCurve } }
        }
        ColumnLayout {
            anchors.fill: parent; anchors.margins: Metrics.padding
            CCModule {
                Layout.fillWidth: true; Layout.preferredHeight: 60
                Text { text: "Wi-Fi & Bluetooth"; color: Colors.textPrimary; anchors.centerIn: parent }
            }
            // ... тут добавить слайдеры
        }
    }
}