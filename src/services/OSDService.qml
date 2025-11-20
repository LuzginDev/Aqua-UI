pragma Singleton
import QtQuick

QtObject {
    id: root

    property string activeType: "" 
    property real value: 0
    property bool muted: false
    property string currentLayout: "EN"

    property var _hideTimer: Timer {
        interval: 2000
        repeat: false
        onTriggered: root.activeType = ""
    }

    function restartTimer() {
        if (_hideTimer.running) _hideTimer.restart()
        else _hideTimer.start()
    }

    function showVolume(vol, isMuted) {
        root.value = vol
        root.muted = isMuted
        root.activeType = "volume"
        restartTimer()
    }

    function showBrightness(newValue) {
        root.value = newValue
        root.activeType = "brightness"
        restartTimer()
    }

    function showKeyboard(layout) {
        root.currentLayout = layout
        root.activeType = "keyboard"
        restartTimer()
    }
}