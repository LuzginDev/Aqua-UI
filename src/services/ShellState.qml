pragma Singleton
import QtQuick

QtObject {
    property bool isControlCenterOpen: false
    property bool isAppLauncherOpen: false
    property bool isOverviewOpen: false
    
    function toggleControlCenter() {
        var newState = !isControlCenterOpen
        if (newState) closeAll()
        isControlCenterOpen = newState
    }

    function toggleAppLauncher() {
        var newState = !isAppLauncherOpen
        if (newState) closeAll()
        isAppLauncherOpen = newState
    }
    
    function toggleOverview() {
        var newState = !isOverviewOpen
        if (newState) closeAll()
        isOverviewOpen = newState
    }
    
    function closeAll() {
        isControlCenterOpen = false
        isAppLauncherOpen = false
        isOverviewOpen = false
    }
}