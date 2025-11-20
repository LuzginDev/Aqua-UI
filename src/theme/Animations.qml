pragma Singleton
import QtQuick

QtObject {
    property int fast: 150
    property int medium: 250
    property int slow: 400

    property var smoothCurve: Easing.OutQuart
    property var popUpCurve: Easing.OutBack
    property var springCurve: Easing.OutSine
}