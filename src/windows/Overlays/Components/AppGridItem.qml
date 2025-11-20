import QtQuick
import "../../../theme"

Item {
    id: root
    
    property var appData: null // Объект приложения (из модели Quickshell)
    signal launched()

    width: 100
    height: 130

    Column {
        anchors.centerIn: parent
        spacing: 8

        // --- Иконка ---
        Image {
            id: iconImg
            anchors.horizontalCenter: parent.horizontalCenter
            width: 64
            height: 64
            source: root.appData ? root.appData.icon : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
            
            // Анимация нажатия
            scale: mouseArea.pressed ? 0.9 : (mouseArea.containsMouse ? 1.1 : 1.0)
            Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
        }

        // --- Название ---
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            text: root.appData ? root.appData.name : ""
            
            color: "white" // Всегда белый на темном фоне
            font.pixelSize: Metrics.fontSizeBody
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            
            // Тень для читаемости
            style: Text.Outline
            styleColor: Qt.rgba(0,0,0, 0.5)
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            if (root.appData) {
                root.appData.launch()
                root.launched()
            }
        }
    }
}