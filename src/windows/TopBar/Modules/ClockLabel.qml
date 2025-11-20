import QtQuick
import "../../../theme"

Text {
    id: clockText
    font.pixelSize: Metrics.fontSizeBody
    font.weight: Font.Medium
    color: Colors.textPrimary
    
    function updateTime() { text = Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm") }
    Component.onCompleted: updateTime()
    Timer { interval: 1000; running: true; repeat: true; onTriggered: clockText.updateTime() }
}