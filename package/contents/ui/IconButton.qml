import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: root

    property string source: ""
    signal clicked()

    Layout.preferredWidth:  width
    Layout.preferredHeight: height

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
        anchors.fill: parent
        hoverEnabled: true

       onClicked: root.clicked()
    }
}
