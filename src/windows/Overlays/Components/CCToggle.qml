import QtQuick
import "../../../theme"

Rectangle {
    id: root
    property string iconSource: ""
    property string label: ""
    property bool active: false
    property string command: "" 
    
    signal clicked()

    width: 50
    height: 50
    radius: 25
    color: active ? Colors.textAccent : (Colors.isDark ? Qt.rgba(1,1,1, 0.1) : Qt.rgba(0,0,0, 0.05))
    
    Behavior on color { ColorAnimation { duration: 150 } }

    Image {
        anchors.centerIn: parent
        width: 20; height: 20
        source: root.iconSource
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.active = !root.active
            root.clicked()
            // Здесь можно вызвать bash скрипт через Hyprland dispatch, если нужно
        }
    }
}