pragma Singleton
import QtQuick

QtObject {
    property bool isDark: true
    
    property color background: isDark ? Qt.rgba(0.1, 0.1, 0.1, 0.65) : Qt.rgba(0.95, 0.95, 0.95, 0.65)
    property color selection: isDark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.05)
    property color border: isDark ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.1)
    property color tooltipBg: isDark ? Qt.rgba(0.2, 0.2, 0.2, 0.9) : Qt.rgba(0.9, 0.9, 0.9, 0.9)

    property color textPrimary: isDark ? "#FFFFFF" : "#000000"
    property color textSecondary: isDark ? Qt.rgba(1, 1, 1, 0.6) : Qt.rgba(0, 0, 0, 0.5)
    property color textAccent: "#007AFF"
    
    property color red: "#FF5F57"
    property color yellow: "#FEBC2E"
    property color green: "#28C840"
}