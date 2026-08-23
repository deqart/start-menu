import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid

import org.dekart.start as StartMenu

PlasmoidItem {
    id: root

    StartMenu.Backend {
        id: backend
        onHideRequested: {
            root.expanded = false
        }
    }

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
                    bottom: sessionRow.top

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
                            anchors.verticalCenter: parent.verticalCenter
                            source: modelData.icon
                        }

                        PlasmaComponents.Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name
                            elide: Text.ElideRight
                            color: Kirigami.Theme.textColor
                        }
                    }

                    onClicked: {
                        backend.launchApplication(modelData.exec);
                    }
                }
            }

            RowLayout {
                id: sessionRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 8

                RowLayout {
                    ProfileIcon {
                        width:  40
                        height: 40
                        anchors.verticalCenter: parent.verticalCenter
                        source: backend.userProfilePicture
                    }

                    Kirigami.Heading {
                        anchors.verticalCenter: parent.verticalCenter
                        text: backend.userName
                        elide: Text.ElideRight
                    }
                }

                RowLayout {
                    anchors.right: parent.right

                    IconButton {
                        width:  40
                        height: 40
                        source: "system-lock-screen"
                        onClicked: {
                            backend.lockScreen()
                        }
                    }

                    IconButton {
                        width:  40
                        height: 40
                        source: "system-log-out"
                        onClicked: {
                            backend.logoutDialog()
                        }
                    }

                    IconButton {
                        width:  40
                        height: 40
                        source: "system-reboot"
                        onClicked: {
                            backend.restartDialog()
                        }
                    }

                    IconButton {
                        width:  40
                        height: 40
                        source: "system-shutdown"
                        onClicked: {
                            backend.shutdownDialog()
                        }
                    }
                }
            }
        }
    }
}
