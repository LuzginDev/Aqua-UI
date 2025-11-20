import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../../../theme"

Rectangle {
    id: root
    property var currentPlayer: Mpris.players.length > 0 ? Mpris.players[0] : null
    property bool isPlaying: currentPlayer ? (currentPlayer.playbackStatus === MprisPlaybackStatus.Playing) : false

    visible: currentPlayer !== null && (isPlaying || currentPlayer.loopStatus !== MprisLoopStatus.None)
    
    implicitHeight: 24
    implicitWidth: mediaRow.implicitWidth + 16
    radius: 12
    color: Colors.selection

    opacity: visible ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 300 } }

    RowLayout {
        id: mediaRow
        anchors.centerIn: parent
        spacing: 6

        Image {
            source: "image://icon/audio-x-generic-symbolic"
            Layout.preferredWidth: 12
            Layout.preferredHeight: 12
            fillMode: Image.PreserveAspectFit
        }

        Text {
            text: root.currentPlayer ? (root.currentPlayer.artist + " - " + root.currentPlayer.title) : ""
            font.pixelSize: Metrics.fontSizeSmall
            font.weight: Font.Medium
            color: Colors.textPrimary
            elide: Text.ElideRight
            Layout.maximumWidth: 150
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: if (root.currentPlayer) root.currentPlayer.playPause()
    }
}