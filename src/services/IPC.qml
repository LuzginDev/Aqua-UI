pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "."

QtObject {
    property var socket: Socket {
        path: "/tmp/aqua.sock"
        type: SocketType.Stream
        unlink: true
        active: true

        onConnected: console.log("IPC Client connected")
        onRead: (data) => {
            var cleanData = data.trim()
            var parts = cleanData.split(":")
            var command = parts[0]

            if (command === "brightness") {
                OSDService.showBrightness(parseFloat(parts[1]))
            } 
            else if (command === "volume") {
                OSDService.showVolume(parseFloat(parts[1]), (parts[2] === "true"))
            }
            else if (command === "keyboard") {
                OSDService.showKeyboard(parts[1])
            }
            else if (command === "overview") {
                ShellState.toggleOverview()
            }
            else if (command === "launcher") {
                ShellState.toggleAppLauncher()
            }
        }
    }
}