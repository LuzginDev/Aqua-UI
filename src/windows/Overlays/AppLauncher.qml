import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Applications
import "../../theme"
import "../../services"
import "./Components"

PanelWindow {
    id: launcherWindow
    anchors.fill: parent
    layer: Layer.Overlay
    exclusionMode: ExclusionMode.Ignore

    // Анимация видимости
    visible: opacity > 0
    opacity: ShellState.isAppLauncherOpen ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 250 } }
    
    // Зум-эффект (Zoom In)
    scale: ShellState.isAppLauncherOpen ? 1.0 : 1.1
    Behavior on scale { NumberAnimation { duration: 250 } }

    color: "transparent"

    // Клик по фону закрывает
    MouseArea {
        anchors.fill: parent
        onClicked: ShellState.toggleAppLauncher()
        z: -1
    }

    // Затемнение фона
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.45)
    }

    Column {
        anchors.fill: parent
        anchors.topMargin: 80
        spacing: 20

        // --- Поиск ---
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 300
            height: 36
            radius: 10
            color: Qt.rgba(1, 1, 1, 0.2)
            border.color: Qt.rgba(1, 1, 1, 0.3)
            border.width: 1

            TextInput {
                id: searchInput
                anchors.fill: parent
                anchors.margins: 12
                verticalAlignment: TextInput.AlignVCenter
                text: ""
                color: "white"
                font.pixelSize: 14
                
                Text {
                    text: "Search"
                    color: "white"
                    opacity: 0.5
                    visible: !parent.text && !parent.activeFocus
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // --- Сетка ---
        GridView {
            id: gridView
            width: parent.width
            height: parent.height - 120
            clip: true
            cellWidth: 120
            cellHeight: 150
            
            // Берем список приложений из Quickshell
            model: ApplicationSystem.apps
            
            delegate: AppGridItem {
                // Фильтрация по поиску
                property bool matchesSearch: searchInput.text === "" || 
                                           modelData.name.toLowerCase().includes(searchInput.text.toLowerCase())
                
                visible: matchesSearch
                width: matchesSearch ? 100 : 0
                height: matchesSearch ? 130 : 0
                
                appData: modelData
                
                onLaunched: {
                    ShellState.toggleAppLauncher()
                    searchInput.text = ""
                }
            }
        }
    }
    
    // Фокус на поиск при открытии
    onVisibleChanged: {
        if (visible) searchInput.forceActiveFocus()
        else searchInput.text = ""
    }
}