import QtQuick
import QtQuick.Controls
import Quickshell.Services.Hyprland
import "../../../theme"
import "../../../services"

Item {
    id: root
    
    property var windowData // Данные окна из Hyprland
    signal clicked()

    width: 240
    height: 180

    // Контейнер
    Rectangle {
        anchors.fill: parent
        anchors.margins: 10
        color: Colors.background
        radius: 12
        border.color: hoverHandler.hovered ? Colors.textAccent : Colors.border
        border.width: hoverHandler.hovered ? 2 : 1
        
        scale: hoverHandler.hovered ? 1.05 : 1.0
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }

        // --- Скриншот ---
        Image {
            id: thumb
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            anchors.bottom: infoBar.top
            anchors.margins: 4
            fillMode: Image.PreserveAspectCrop
            
            cache: false
            asynchronous: true
            
            // Базовый путь к файлу в /tmp
            property string basePath: "file:///tmp/aqua_thumbs/" + (root.windowData ? root.windowData.address : "") + ".png"
            source: basePath

            // Таймер для живого обновления (фоновые окна)
            Timer {
                interval: 5000 
                running: ShellState.isOverviewOpen && root.visible
                repeat: true
                onTriggered: {
                    var timestamp = new Date().getTime()
                    thumb.source = "" 
                    thumb.source = thumb.basePath + "?t=" + timestamp
                }
            }
            
            // Заглушка, если скриншота нет
            Rectangle {
                visible: thumb.status !== Image.Ready
                anchors.fill: parent
                color: Qt.rgba(0.5, 0.5, 0.5, 0.2)
                Image {
                    anchors.centerIn: parent; width: 48; height: 48
                    source: "image://icon/" + (root.windowData ? root.windowData.class : "")
                }
            }
        }

        // --- Подвал (Иконка + Название + Закрыть) ---
        Rectangle {
            id: infoBar
            height: 32
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            color: "transparent"

            Image {
                anchors.left: parent.left; anchors.leftMargin: 8; anchors.verticalCenter: parent.verticalCenter
                width: 16; height: 16
                source: "image://icon/" + (root.windowData ? root.windowData.class : "")
            }

            Text {
                anchors.left: parent.left; anchors.leftMargin: 30; anchors.right: closeBtn.left
                anchors.verticalCenter: parent.verticalCenter
                text: root.windowData ? root.windowData.title : ""
                elide: Text.ElideRight
                color: Colors.textPrimary
                font.pixelSize: 11
            }

            // Кнопка закрытия
            Rectangle {
                id: closeBtn
                width: 20; height: 20; radius: 10
                color: Colors.red
                anchors.right: parent.right; anchors.rightMargin: 8; anchors.verticalCenter: parent.verticalCenter
                visible: hoverHandler.hovered
                
                Text { anchors.centerIn: parent; text: "×"; color: "white" }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("closewindow", "address:" + root.windowData.address)
                }
            }
        }
    }

    HoverHandler { id: hoverHandler }
    MouseArea {
        anchors.fill: parent; z: -1
        onClicked: root.clicked()
    }
}