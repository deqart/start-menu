import QtQuick
import QtQuick.Effects
import org.kde.kirigami as Kirigami

Item {
    id: root

    property string source: ""

    Kirigami.Icon {
        id: profileIcon
        anchors.centerIn: parent
        source: root.source
        visible: false
    }

    Rectangle {
        id: mask
        anchors.fill: profileIcon
        radius: width / 2
        layer.enabled: true
        layer.smooth: true
        visible: false
    }

    Rectangle {
        anchors.fill: profileIcon
        radius: width / 2
        color: Kirigami.Theme.textColor
    }

    MultiEffect {
        anchors.fill: profileIcon
        anchors.margins: 2
        source: profileIcon
        maskEnabled: true
        maskSource: mask
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
    }
}
