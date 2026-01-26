import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
    color: Colors.bgDark
    radius: 15

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // Profile picture
        Rectangle {
            width: 80
            height: 80
            radius: 40
            color: Colors.bgLight
            clip: true

            Image {
                anchors.fill: parent
                anchors.margins: 2
                source: "file://" + StandardPaths.homeDirectory + "/.config/quickshell/pfp.jpg"
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: MultiEffect {
                    maskEnabled: true
                    maskSource: Rectangle {
                        width: 76
                        height: 76
                        radius: 38
                    }
                }
            }
        }

        // Name and uptime
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            Text {
                text: "Harman"
                color: Colors.accent
                font.pixelSize: 28
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
            }

            Text {
                id: uptimeText
                text: "up loading..."
                color: Colors.textSecondary
                font.pixelSize: 12
                font.family: "JetBrainsMono Nerd Font"

                Process {
                    id: uptimeProcess
                    command: ["bash", "-c", "uptime -p | sed 's/up //'"]
                    running: true
                    onExited: {
                        uptimeText.text = "up " + stdout.trim()
                    }
                }

                Timer {
                    interval: 60000
                    running: true
                    repeat: true
                    onTriggered: uptimeProcess.running = true
                }
            }
        }
    }
}
