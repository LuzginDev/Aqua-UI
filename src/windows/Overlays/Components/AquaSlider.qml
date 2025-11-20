import QtQuick
import "../../../theme"

Item {
    id: root
    property string iconSource: ""
    property real value: 0.5 // 0.0 - 1.0
    
    // Для биндинга изменений (если двигаем мышкой)
    // В данном примере пока только отображение, но можно добавить MouseArea для drag
    
    height: 28

    // Фон (трек)
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Colors.isDark ? Qt.rgba(1,1,1, 0.15) : Qt.rgba(0,0,0, 0.1)
        
        // Заполненная часть
        Rectangle {
            width: parent.width * root.value
            height: parent.height
            radius: parent.radius
            color: Colors.textPrimary
            
            Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCirc } }
        }
    }

    // Иконка внутри
    Image {
        source: root.iconSource
        width: 16; height: 16
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.8
    }
}