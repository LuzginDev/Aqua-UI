import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: wallpaperWindow
    anchors.fill: parent
    layer: Layer.Background
    exclusionMode: ExclusionMode.Ignore
    property string wallpaperSource: "../../assets/backgrounds/wallpaper.jpg" 

    Image {
        anchors.fill: parent
        source: parent.wallpaperSource
        fillMode: Image.PreserveAspectCrop
        smooth: true
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.1
        }
    }
}