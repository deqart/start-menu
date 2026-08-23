import QtQuick
import org.kde.kirigami as Kirigami

Item {
    id: root

    property string source: ""
    signal clicked()

    Kirigami.Icon {
        id: iconItem
        source: root.source
        width:  width
        height: height
        anchors.centerIn: parent

        active: area.containsMouse
    }

    MouseArea {
        id: area
        anchors.fill: iconItem
        hoverEnabled: true

       onClicked: root.clicked()
    }
}
