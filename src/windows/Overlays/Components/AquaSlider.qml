import QtQuick
import "../../../theme"

Item {
    id: root
    property string iconSource: ""
    property real value: 0 
    property bool interactive: true
    
    signal moved(real newValue)

    height: 28
    implicitWidth: 200

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: Colors.isDark ? Qt.rgba(1,1,1, 0.15) : Qt.rgba(0,0,0, 0.1)
        
        Rectangle {
            height: parent.height
            radius: parent.radius
            width: Math.max(parent.height, parent.width * root.value)
            color: Colors.textPrimary
            
            Behavior on width { 
                enabled: !mouseArea.pressed
                NumberAnimation { duration: 150; easing.type: Easing.OutCirc } 
            }
        }
    }

    Image {
        source: root.iconSource
        width: 16; height: 16
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        opacity: root.value > 0.1 ? 0 : 1 
        Behavior on opacity { NumberAnimation { duration: 150 } }
        
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: Colors.textSecondary
            visible: !root.value > 0.1
        }
    }
    
    Image {
        source: root.iconSource
        width: 16; height: 16
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        opacity: root.value > 0.1 ? 1 : 0
        
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: Colors.isDark ? "black" : "white"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.interactive
        
        function updateValue(mouseX) {
            var val = Math.max(0, Math.min(1, mouseX / width))
            root.moved(val)
        }

        onPressed: (mouse) => updateValue(mouse.x)
        onPositionChanged: (mouse) => updateValue(mouse.x)
    }
}