import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid

import org.dekart.start as StartMenu

PlasmoidItem {
    id: root

    StartMenu.Backend { id: backend }

    Plasmoid.icon: backend.resolvedIcon

    fullRepresentation: Item {
        Layout.preferredWidth:  400
        Layout.preferredHeight: 400

        Layout.minimumWidth:  400
        Layout.minimumHeight: 400

        Layout.maximumWidth:  400
        Layout.maximumHeight: 400

        ColumnLayout {
            anchors.fill: parent

            ListView {
                id: listView

                anchors {
                    top:   parent.top
                    left:  parent.left
                    right: parent.right
                    bottom: sessionOptions.top

                    margins: 12
                }
                model: backend.applicationList
                clip: true

                delegate: PlasmaComponents.ItemDelegate {
                    width: listView.width
                    height: 48

                    contentItem: Row {
                        spacing: 12
                        anchors.verticalCenter: parent.verticalCenter

                        Kirigami.Icon {
                            width: 32
                            height: 32
                            source: modelData.icon
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        PlasmaComponents.Label {
                            text: modelData.name
                            elide: Text.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                            color: Kirigami.Theme.textColor
                        }
                    }

                    onClicked: {
                        backend.launchApplication(modelData.exec);
                    }
                }
            }

            RowLayout {
                id: sessionOptions
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 8

                IconButton {
                    source: "system-lock-screen"
                    width:  40
                    height: 40
                    onClicked: {
                        backend.lockScreen()
                    }
                }

                IconButton {
                    source: "system-log-out"
                    width:  40
                    height: 40
                    onClicked: {
                        backend.logoutDialog()
                    }
                }

                IconButton {
                    source: "system-reboot"
                    width:  40
                    height: 40
                    onClicked: {
                        backend.restartDialog()
                    }
                }

                IconButton {
                    source: "system-shutdown"
                    width:  40
                    height: 40
                    onClicked: {
                        backend.shutdownDialog()
                    }
                }
            }
        }
    }
}
