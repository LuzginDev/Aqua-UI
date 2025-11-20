import QtQuick
import QtQuick.Layouts
import "../theme"

Rectangle {
    id: root
    property string text: ""
    property string iconSource: ""
    property int horizontalPadding: 8
    signal clicked()
    
    default property alias content: contentLayout.data

    implicitWidth: contentLayout.implicitWidth + (horizontalPadding * 2)
    implicitHeight: Metrics.topBarHeight - 6
    radius: 6
    
    color: mouseArea.containsMouse ? Colors.selection : "transparent"
    scale: mouseArea.pressed ? 0.95 : 1.0
    
    Behavior on color { ColorAnimation { duration: 100 } }
    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }

    RowLayout {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 6
        
        Image {
            visible: root.iconSource !== ""
            source: root.iconSource
            Layout.preferredWidth: 16; Layout.preferredHeight: 16
            fillMode: Image.PreserveAspectFit
        }
        Text {
            visible: root.text !== ""
            text: root.text
            font.pixelSize: Metrics.fontSizeBody
            color: Colors.textPrimary
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}