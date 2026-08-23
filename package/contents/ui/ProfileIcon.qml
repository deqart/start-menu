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
        border.color: Kirigami.Theme.textColor
        border.width: 2
        layer.enabled: true
        visible: false
    }

    MultiEffect {
        anchors.fill: profileIcon
        source: profileIcon
        maskEnabled: true
        maskSource: mask
    }
}
