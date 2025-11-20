import QtQuick
import Quickshell
// Import folders for singletons
import "./src/theme"
import "./src/services"

ShellRoot {
    // Initialize IPC service on startup
    Component.onCompleted: {
        IPC
    }
    Scope { url: "./src/windows/Background/WallpaperWindow.qml" }
    Scope { url: "./src/windows/TopBar/BarWindow.qml" }
    Scope { url: "./src/windows/Dock/DockWindow.qml" }
    Scope { url: "./src/windows/Overlays/ControlCenter.qml" }
    Scope { url: "./src/windows/Overlays/AppLauncher.qml" }
    Scope { url: "./src/windows/Overlays/Overview.qml" }
    Scope { url: "./src/windows/Overlays/OSD.qml" }
}