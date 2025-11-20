import QtQuick
import "../../theme"

Item {
    id: root
    property string iconSource: ""
    property string appName: ""
    property bool isRunning: false
    property real dockMouseX: -1
    property bool dockHovered: false
    signal clicked()

    width: Metrics.dockSize * scaleFactor
    height: Metrics.dockSize * scaleFactor
    property real scaleFactor: 1.0

    function updateScale() {
        if (!dockHovered || dockMouseX === -1) { scaleFactor = 1.0; return }
        var center = root.mapToItem(root.parent.parent, root.width / 2, 0).x
        var distance = Math.abs(dockMouseX - center)
        var range = 150
        if (distance < range) {
            var val = (1 - distance / range)
            scaleFactor = 1.0 + (Math.sin(val * Math.PI / 2) * 0.5)
        } else { scaleFactor = 1.0 }
    }
    onDockMouseXChanged: updateScale()
    Behavior on scaleFactor { NumberAnimation { duration: dockHovered ? 50 : 300; easing.type: Easing.OutSine } }

    Image {
        anchors.centerIn: parent
        width: parent.width; height: parent.height
        source: root.iconSource
        fillMode: Image.PreserveAspectFit
        smooth: true
    }
    Rectangle {
        width: 4; height: 4; radius: 2; color: Colors.textPrimary
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        visible: root.isRunning
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}