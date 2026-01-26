//there are some problems with the timing and stuff. i use firefox so i think its a MPRIS issue. if you find a fix please let me know.

import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    property bool musicVisible: false
    property real trackedPosition: 0
    property bool wasPlaying: false

    MprisWatcher {
        id: mprisWatcher
    }

    property var player: mprisWatcher.players.values[0] ?? null
    property bool isActuallyPlaying: (root.player?.isPlaying ?? false) && (root.player?.playbackState === MprisPlaybackState.Playing)

    Timer {
        id: positionTimer
        interval: 1000
        running: root.musicVisible && root.isActuallyPlaying
        repeat: true
        onTriggered: {
            root.trackedPosition = root.trackedPosition + 1
            if (root.trackedPosition > (root.player?.length ?? 0)) {
                root.trackedPosition = root.player?.length ?? 0
            }
        }
    }

    Timer {
        id: syncTimer
        interval: 5000
        running: root.musicVisible && root.isActuallyPlaying
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (root.player) {
                var pos = root.player.position
                var len = root.player.length
                if (pos > 0 && pos < len - 5) {
                    root.trackedPosition = pos
                }
            }
        }
    }

    Connections {
        target: root.player
        function onTrackTitleChanged() {
            root.trackedPosition = 0
        }
    }

    PanelWindow {
        id: musicPanel

        visible: root.musicVisible
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            right: true
        }

        margins {
            top: 50
            right: 10
        }

        implicitWidth: 400
        implicitHeight: 180
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "#101219"
            radius: 15
            opacity: 0.95

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Text {
                        text: root.player?.trackTitle ?? "Nothing is playing"
                        color: "#D9C7A9"
                        font.pixelSize: 16
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: root.player?.trackArtist ?? ""
                        color: "#e5e5de"
                        font.pixelSize: 13
                        font.family: "JetBrainsMono Nerd Font"
                        opacity: 0.7
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        visible: (root.player?.trackArtist ?? "") !== ""
                    }

                    Item { Layout.fillHeight: true }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        visible: root.player !== null

                        Text {
                            text: formatTime(root.trackedPosition)
                            color: "#a0a09b"
                            font.pixelSize: 10
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 4
                            radius: 2
                            color: Qt.rgba(0, 0, 0, 0.3)

                            Rectangle {
                                property real safeLength: root.player?.length ?? 1
                                width: safeLength > 0 
                                    ? parent.width * (root.trackedPosition / safeLength) 
                                    : 0
                                height: parent.height
                                radius: 2
                                color: "#D9C7A9"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: function(mouse) {
                                    if (root.player && root.player.length > 0) {
                                        var seekPos = (mouse.x / parent.width) * root.player.length
                                        root.trackedPosition = seekPos
                                        root.player.position = seekPos
                                    }
                                }
                            }
                        }

                        Text {
                            text: formatTime(root.player?.length ?? 0)
                            color: "#a0a09b"
                            font.pixelSize: 10
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignLeft
                        spacing: 15
                        opacity: root.player !== null ? 1.0 : 0.5

                        Rectangle {
                            width: 35
                            height: 35
                            radius: 8
                            color: prevMa.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "⏮"
                                color: "#e5e5de"
                                font.pixelSize: 16
                            }

                            MouseArea {
                                id: prevMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.player?.previous()
                            }
                        }

                        Rectangle {
                            width: 45
                            height: 45
                            radius: 22
                            color: "#D9C7A9"

                            Text {
                                anchors.centerIn: parent
                                text: root.isActuallyPlaying ? "⏸" : "▶"
                                color: "#101219"
                                font.pixelSize: 18
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.player?.togglePlaying()
                            }
                        }

                        Rectangle {
                            width: 35
                            height: 35
                            radius: 8
                            color: nextMa.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "⏭"
                                color: "#e5e5de"
                                font.pixelSize: 16
                            }

                            MouseArea {
                                id: nextMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.player?.next()
                            }
                        }
                    }
                }

                AnimatedImage {
                    id: honeypieImage
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 140
                    Layout.alignment: Qt.AlignVCenter

                    source: "file:///home/harman/.config/quickshell/assets/honeypie.gif"

                    fillMode: Image.PreserveAspectFit
                    playing: root.isActuallyPlaying
                    paused: !root.isActuallyPlaying
                }
            }
        }

        function formatTime(seconds) {
            var mins = Math.floor(seconds / 60)
            var secs = Math.floor(seconds % 60)
            return mins + ":" + (secs < 10 ? "0" : "") + secs
        }
    }

    IpcHandler {
        target: "music"

        function toggle(): void {
            root.musicVisible = !root.musicVisible
        }

        function show(): void {
            root.musicVisible = true
        }

        function hide(): void {
            root.musicVisible = false
        }
    }
}