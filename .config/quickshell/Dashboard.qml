import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "components"

PanelWindow {
    id: dashboardWindow

    anchors {
        top: true
        bottom: true
        right: true
    }

    margins {
        top: 10
        bottom: 10
        right: 10
    }

    width: 420
    color: "transparent"

    Rectangle {
        id: container
        anchors.fill: parent
        color: "transparent"
        radius: 20
        clip: true

        // Background image with blur
        Image {
            id: bgImage
            anchors.fill: parent
            source: "file://" + StandardPaths.homeDirectory + "/.config/quickshell/background.jpg"
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        MultiEffect {
            source: bgImage
            anchors.fill: parent
            blurEnabled: true
            blurMax: 64
            blur: 1.0
        }

        // Dark overlay
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.6)
            radius: 20
        }

        // Main content
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Profile Section
            ProfileSection {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
            }

            // Power buttons row
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                color: Colors.bgDark
                radius: 15

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 20

                    PowerButton { icon: "⏻"; action: "systemctl poweroff"; tipText: "Shutdown" }
                    PowerButton { icon: "󰜉"; action: "systemctl reboot"; tipText: "Reboot" }
                    PowerButton { icon: "󰌾"; action: "hyprlock"; tipText: "Lock" }
                    PowerButton { icon: "󰒲"; action: "systemctl suspend"; tipText: "Sleep" }
                    PowerButton { icon: "󰍃"; action: "hyprctl dispatch exit"; tipText: "Logout" }
                }
            }

            // System Stats
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 280
                color: Colors.bgDark
                radius: 15

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12

                    StatBar {
                        label: "CPU"
                        icon: ""
                        value: cpuUsage.value
                        color: Colors.color1
                        Layout.fillWidth: true
                    }

                    StatBar {
                        label: "RAM"
                        icon: ""
                        value: ramUsage.value
                        color: Colors.color4
                        Layout.fillWidth: true
                    }

                    StatBar {
                        label: "DISK"
                        icon: ""
                        value: diskUsage.value
                        color: Colors.color2
                        Layout.fillWidth: true
                    }

                    StatBar {
                        label: "BAT"
                        icon: batteryIcon.text
                        value: batteryLevel.value
                        color: Colors.color5
                        Layout.fillWidth: true
                    }

                    // Volume slider
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "󰕾"
                            color: Colors.color6
                            font.pixelSize: 18
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: Qt.rgba(0, 0, 0, 0.3)

                            Rectangle {
                                width: parent.width * (volumeLevel.value / 100)
                                height: parent.height
                                radius: 4
                                color: Colors.color6
                            }
                        }

                        Text {
                            text: volumeLevel.value + "%"
                            color: Colors.textSecondary
                            font.pixelSize: 11
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }

                    // Brightness slider
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "󰃠"
                            color: Colors.color3
                            font.pixelSize: 18
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: Qt.rgba(0, 0, 0, 0.3)

                            Rectangle {
                                width: parent.width * (brightnessLevel.value / 100)
                                height: parent.height
                                radius: 4
                                color: Colors.color3
                            }
                        }

                        Text {
                            text: brightnessLevel.value + "%"
                            color: Colors.textSecondary
                            font.pixelSize: 11
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }
                }
            }

            // Calendar
            CalendarWidget {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    // Data providers
    Process {
        id: cpuProcess
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print int($2)}'"]
        running: true
        onExited: {
            cpuUsage.value = parseInt(stdout.trim()) || 0
            restartTimer.start()
        }
    }

    Process {
        id: ramProcess
        command: ["bash", "-c", "free | awk '/Mem:/ {printf \"%.0f\", $3/$2 * 100}'"]
        running: true
        onExited: {
            ramUsage.value = parseInt(stdout.trim()) || 0
        }
    }

    Process {
        id: diskProcess
        command: ["bash", "-c", "df / | awk 'NR==2 {print int($5)}'"]
        running: true
        onExited: {
            diskUsage.value = parseInt(stdout.trim()) || 0
        }
    }

    Process {
        id: batteryProcess
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100"]
        running: true
        onExited: {
            batteryLevel.value = parseInt(stdout.trim()) || 100
        }
    }

    Process {
        id: batteryStatusProcess
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo 'Unknown'"]
        running: true
        onExited: {
            var status = stdout.trim()
            var cap = batteryLevel.value
            if (status === "Charging") batteryIcon.text = "󰂄"
            else if (cap >= 90) batteryIcon.text = "󰁹"
            else if (cap >= 70) batteryIcon.text = "󰂀"
            else if (cap >= 50) batteryIcon.text = "󰁾"
            else if (cap >= 30) batteryIcon.text = "󰁼"
            else batteryIcon.text = "󰁻"
        }
    }

    Process {
        id: volumeProcess
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"%.0f\", $2 * 100}'"]
        running: true
        onExited: {
            volumeLevel.value = parseInt(stdout.trim()) || 0
        }
    }

    Process {
        id: brightnessProcess
        command: ["bash", "-c", "brightnessctl -m | awk -F, '{gsub(/%/, \"\", $4); print $4}'"]
        running: true
        onExited: {
            brightnessLevel.value = parseInt(stdout.trim()) || 100
        }
    }

    Timer {
        id: restartTimer
        interval: 2000
        onTriggered: {
            cpuProcess.running = true
            ramProcess.running = true
            diskProcess.running = true
            batteryProcess.running = true
            batteryStatusProcess.running = true
            volumeProcess.running = true
            brightnessProcess.running = true
        }
    }

    QtObject {
        id: cpuUsage
        property int value: 0
    }

    QtObject {
        id: ramUsage
        property int value: 0
    }

    QtObject {
        id: diskUsage
        property int value: 0
    }

    QtObject {
        id: batteryLevel
        property int value: 100
    }

    QtObject {
        id: batteryIcon
        property string text: "󰁹"
    }

    QtObject {
        id: volumeLevel
        property int value: 50
    }

    QtObject {
        id: brightnessLevel
        property int value: 100
    }

    component PowerButton: Rectangle {
        property string icon: ""
        property string action: ""
        property string tipText: ""

        width: 40
        height: 40
        radius: 10
        color: mouseArea.containsMouse ? Colors.bgLight : "transparent"

        Text {
            anchors.centerIn: parent
            text: icon
            color: Colors.accent
            font.pixelSize: 18
            font.family: "JetBrainsMono Nerd Font"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                Qt.callLater(function() {
                    var proc = Qt.createQmlObject('import Quickshell.Io; Process {}', dashboardWindow)
                    proc.command = ["bash", "-c", action]
                    proc.running = true
                })
            }
        }

        ToolTip {
            visible: mouseArea.containsMouse
            text: tipText
        }
    }
}
