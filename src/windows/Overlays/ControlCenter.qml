import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Services.Hyprland
import "../../theme"
import "../../components"
import "../../services"
import "./Components"

PanelWindow {
    id: ccWindow

    anchors { top: true; right: true }
    margins { top: Metrics.topBarHeight + 10; right: 10 }

    width: 340
    height: mainCol.implicitHeight + (Metrics.padding * 2)

    color: "transparent"
    layer: Layer.Overlay
    
    visible: opacity > 0
    opacity: ShellState.isControlCenterOpen ? 1 : 0
    
    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

    GlassPanel {
        anchors.fill: parent
        
        transform: Translate {
            y: ShellState.isControlCenterOpen ? 0 : -30
            Behavior on y { NumberAnimation { duration: 300; easing.type: Animations.popUpCurve } }
        }

        ColumnLayout {
            id: mainCol
            anchors.fill: parent
            anchors.margins: Metrics.padding
            spacing: Metrics.padding

            RowLayout {
                spacing: Metrics.padding
                Layout.fillWidth: true
                Layout.preferredHeight: 160 

                CCModule {
                    Layout.preferredWidth: 160
                    Layout.fillHeight: true
                    
                    GridLayout {
                        anchors.centerIn: parent
                        columns: 2
                        rowSpacing: 15
                        columnSpacing: 15

                        CCToggle {
                            iconSource: "image://icon/network-wireless-signal-excellent-symbolic"
                            active: true 
                            onClicked: console.log("Toggle Wifi")
                        }
                        CCToggle {
                            iconSource: "image://icon/bluetooth-active-symbolic"
                            active: true 
                            onClicked: console.log("Toggle BT")
                        }
                        CCToggle {
                            iconSource: "image://icon/airplane-mode-symbolic"
                            active: false
                            onClicked: console.log("Toggle Airplane")
                        }
                        CCToggle {
                            iconSource: "image://icon/focus-legacy-symbolic" 
                            active: false
                            onClicked: console.log("Toggle DND")
                        }
                    }
                }

                ColumnLayout {
                    spacing: Metrics.padding
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    CCModule {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            
                            Image {
                                source: "image://icon/weather-clear"
                                Layout.preferredWidth: 32; Layout.preferredHeight: 32
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "Dnipro"
                                color: Colors.textPrimary
                                font.pixelSize: Metrics.fontSizeBody
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "+12°C"
                                color: Colors.textSecondary
                                font.pixelSize: Metrics.fontSizeSmall
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }

            CCModule {
                Layout.fillWidth: true
                implicitHeight: 100
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12
                    
                    RowLayout {
                        Text { text: "Display"; font.pixelSize: 11; color: Colors.textSecondary; font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                    }
                    
                    AquaSlider {
                        Layout.fillWidth: true
                        iconSource: "image://icon/display-brightness-symbolic"
                        value: 0.7 
                        onMoved: (val) => {
                            // Вызываем наш скрипт яркости
                            // brightnessctl ожидает проценты 0-100%
                            var percent = Math.round(val * 100) + "%"
                            Hyprland.dispatch("exec", "brightnessctl s " + percent + " -q")
                        }
                    }
                    
                    RowLayout {
                        Text { text: "Sound"; font.pixelSize: 11; color: Colors.textSecondary; font.weight: Font.Bold }
                        Item { Layout.fillWidth: true }
                    }

                    AquaSlider {
                        Layout.fillWidth: true
                        iconSource: "image://icon/audio-volume-high"
                        
                        // Двусторонняя привязка к Pipewire
                        value: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
                        
                        onMoved: (val) => {
                            if (Pipewire.defaultAudioSink) {
                                Pipewire.defaultAudioSink.audio.volume = val
                            }
                        }
                    }
                }
            }
        }
    }
}