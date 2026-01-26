import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

ShellRoot {
    id: root

    property bool dashboardVisible: false
    property bool musicVisible: false

    PanelWindow {
        id: dashboard

        visible: true
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            bottom: true
            right: true
        }

        margins {
            top: 40
            bottom: 10
            right: root.dashboardVisible ? 6 : -450  
        }

        implicitWidth: 420
        color: "transparent"

        Behavior on margins.right {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#101219"
            radius: 20
            opacity: 0.95

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 15

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Rectangle {
                            width: 74
                            height: 74
                            radius: 37
                            color: "#D9C7A9"

                            Image {
                                anchors.centerIn: parent
                                width: 68
                                height: 68
                                source: "file:///home/harman/.config/quickshell/pfp_circle.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            Text {
                                text: "Harman" //change this to your name
                                color: "#D9C7A9"
                                font.pixelSize: 26
                                font.bold: true
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            Text {
                                id: uptimeText
                                text: "up ..."
                                color: "#e5e5de"
                                font.pixelSize: 12
                                font.family: "JetBrainsMono Nerd Font"
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 15

                    Row {
                        anchors.centerIn: parent
                        spacing: 25

                        PowerBtn { icon: "⏻"; iconColor: "#9EA7A3"; cmd: "systemctl poweroff" }
                        PowerBtn { icon: "󰜉"; iconColor: "#E4CDAA"; cmd: "systemctl reboot" }
                        PowerBtn { icon: "󰌾"; iconColor: "#D9C7A9"; cmd: "hyprlock" }
                        PowerBtn { icon: "󰒲"; iconColor: "#A3C0C5"; cmd: "systemctl suspend" }
                        PowerBtn { icon: "󰍃"; iconColor: "#DAC496"; cmd: "hyprctl dispatch exit" }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 15

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Text {
                            id: batIcon
                            text: "󰁹"
                            color: "#E4CDAA"
                            font.pixelSize: 32
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3

                            Text {
                                text: "Battery " + dashboard.batVal + "%"
                                color: "#e5e5de"
                                font.pixelSize: 18
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            Text {
                                id: batStatus
                                text: "Checking..."
                                color: "#a0a09b"
                                font.pixelSize: 12
                                font.family: "JetBrainsMono Nerd Font"
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 15

                    Row {
                        anchors.centerIn: parent
                        spacing: 30

                        CircularStat { label: "CPU"; icon: ""; barColor: "#9EA7A3"; value: dashboard.cpuVal }
                        CircularStat { label: "RAM"; icon: ""; barColor: "#D9C7A9"; value: dashboard.ramVal }
                        CircularStat { label: "DISK"; icon: ""; barColor: "#CCBB9E"; value: dashboard.diskVal }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 15

                    Column {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Row {
                            width: parent.width
                            spacing: 10

                            Text {
                                width: 25
                                text: dashboard.volVal == 0 ? "󰝟" : dashboard.volVal < 50 ? "󰖀" : "󰕾"
                                color: "#A3C0C5"
                                font.pixelSize: 18
                                font.family: "JetBrainsMono Nerd Font"
                                verticalAlignment: Text.AlignVCenter
                                height: 24

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: volMuteProc.running = true
                                }

                                Process {
                                    id: volMuteProc
                                    command: ["bash", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"]
                                    onExited: volProc.running = true
                                }
                            }

                            Rectangle {
                                id: volSlider
                                width: parent.width - 75
                                height: 8
                                anchors.verticalCenter: parent.verticalCenter
                                radius: 4
                                color: Qt.rgba(0,0,0,0.3)

                                Rectangle {
                                    width: parent.width * dashboard.volVal / 100
                                    height: parent.height
                                    radius: 4
                                    color: "#A3C0C5"

                                    Behavior on width {
                                        NumberAnimation { duration: 100 }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: function(mouse) {
                                        var percent = Math.round((mouse.x / parent.width) * 100)
                                        percent = Math.max(0, Math.min(100, percent))
                                        dashboard.volVal = percent
                                        volSetProc.command = ["bash", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + (percent / 100).toFixed(2)]
                                        volSetProc.running = true
                                    }
                                    onPositionChanged: function(mouse) {
                                        if (pressed) {
                                            var percent = Math.round((mouse.x / parent.width) * 100)
                                            percent = Math.max(0, Math.min(100, percent))
                                            dashboard.volVal = percent
                                            volSetProc.command = ["bash", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + (percent / 100).toFixed(2)]
                                            volSetProc.running = true
                                        }
                                    }
                                }

                                Process {
                                    id: volSetProc
                                }
                            }

                            Text {
                                width: 40
                                text: dashboard.volVal + "%"
                                color: "#a0a09b"
                                font.pixelSize: 11
                                font.family: "JetBrainsMono Nerd Font"
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                height: 24
                            }
                        }

                        Row {
                            width: parent.width
                            spacing: 10

                            Text {
                                width: 25
                                text: dashboard.brightVal < 30 ? "󰃞" : dashboard.brightVal < 70 ? "󰃟" : "󰃠"
                                color: "#DAC496"
                                font.pixelSize: 18
                                font.family: "JetBrainsMono Nerd Font"
                                verticalAlignment: Text.AlignVCenter
                                height: 24
                            }

                            Rectangle {
                                id: brightSlider
                                width: parent.width - 75
                                height: 8
                                anchors.verticalCenter: parent.verticalCenter
                                radius: 4
                                color: Qt.rgba(0,0,0,0.3)

                                Rectangle {
                                    width: parent.width * dashboard.brightVal / 100
                                    height: parent.height
                                    radius: 4
                                    color: "#DAC496"

                                    Behavior on width {
                                        NumberAnimation { duration: 100 }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: function(mouse) {
                                        var percent = Math.round((mouse.x / parent.width) * 100)
                                        percent = Math.max(1, Math.min(100, percent))
                                        dashboard.brightVal = percent
                                        brightSetProc.command = ["bash", "-c", "brightnessctl set " + percent + "%"]
                                        brightSetProc.running = true
                                    }
                                    onPositionChanged: function(mouse) {
                                        if (pressed) {
                                            var percent = Math.round((mouse.x / parent.width) * 100)
                                            percent = Math.max(1, Math.min(100, percent))
                                            dashboard.brightVal = percent
                                            brightSetProc.command = ["bash", "-c", "brightnessctl set " + percent + "%"]
                                            brightSetProc.running = true
                                        }
                                    }
                                }

                                Process {
                                    id: brightSetProc
                                }
                            }

                            Text {
                                width: 40
                                text: dashboard.brightVal + "%"
                                color: "#a0a09b"
                                font.pixelSize: 11
                                font.family: "JetBrainsMono Nerd Font"
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                height: 24
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 15

                    Column {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        Text {
                            id: timeDisplay
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "12:00:00 AM"
                            color: "#D9C7A9"
                            font.pixelSize: 40
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Text {
                            id: dateDisplay
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "01.01.2026, Friday"
                            color: "#e5e5de"
                            font.pixelSize: 14
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }
                }
            }
        }

        property int cpuVal: 0
        property int ramVal: 0
        property int diskVal: 0
        property int batVal: 100
        property int volVal: 50
        property int brightVal: 100

        component CircularStat: Item {
            property string label
            property string icon
            property string barColor
            property int value

            width: 90
            height: 110

            Column {
                anchors.centerIn: parent
                spacing: 8

                Item {
                    width: 70
                    height: 70
                    anchors.horizontalCenter: parent.horizontalCenter

                    Shape {
                        anchors.fill: parent
                        ShapePath {
                            fillColor: "transparent"
                            strokeColor: Qt.rgba(0,0,0,0.3)
                            strokeWidth: 5
                            capStyle: ShapePath.RoundCap
                            PathAngleArc {
                                centerX: 35; centerY: 35
                                radiusX: 32; radiusY: 32
                                startAngle: 0; sweepAngle: 360
                            }
                        }
                    }

                    Shape {
                        anchors.fill: parent
                        ShapePath {
                            fillColor: "transparent"
                            strokeColor: barColor
                            strokeWidth: 5
                            capStyle: ShapePath.RoundCap
                            PathAngleArc {
                                centerX: 35; centerY: 35
                                radiusX: 32; radiusY: 32
                                startAngle: -90
                                sweepAngle: value * 3.6
                            }
                        }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: icon
                            color: barColor
                            font.pixelSize: 16
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: value + "%"
                            color: "#e5e5de"
                            font.pixelSize: 14
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: label
                    color: "#a0a09b"
                    font.pixelSize: 11
                    font.family: "JetBrainsMono Nerd Font"
                }
            }
        }

        component PowerBtn: Rectangle {
            property string icon
            property string iconColor
            property string cmd

            width: 40
            height: 40
            radius: 10
            color: powerMa.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent"

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Text {
                anchors.centerIn: parent
                text: icon
                color: iconColor
                font.pixelSize: 18
                font.family: "JetBrainsMono Nerd Font"
            }

            MouseArea {
                id: powerMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: cmdProc.running = true
            }

            Process {
                id: cmdProc
                command: ["bash", "-c", cmd]
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var now = new Date()
                var hours = now.getHours()
                var minutes = now.getMinutes()
                var seconds = now.getSeconds()
                var ampm = hours >= 12 ? 'PM' : 'AM'
                hours = hours % 12
                hours = hours ? hours : 12
                var h = hours < 10 ? '0' + hours : hours
                var m = minutes < 10 ? '0' + minutes : minutes
                var s = seconds < 10 ? '0' + seconds : seconds
                timeDisplay.text = h + ':' + m + ':' + s + ' ' + ampm
                dateDisplay.text = Qt.formatDate(now, "dd.MM.yyyy, dddd")
            }
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                cpuProc.running = true
                ramProc.running = true
                diskProc.running = true
                batProc.running = true
                batStatusProc.running = true
                volProc.running = true
                brightProc.running = true
                uptimeProc.running = true
            }
        }

        Process {
            id: cpuProc
            command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print int($2 + $4)}'"]
            stdout: SplitParser {
                onRead: data => dashboard.cpuVal = parseInt(data) || 0
            }
        }

        Process {
            id: ramProc
            command: ["bash", "-c", "free | awk '/Mem:/ {printf \"%.0f\", $3/$2*100}'"]
            stdout: SplitParser {
                onRead: data => dashboard.ramVal = parseInt(data) || 0
            }
        }

        Process {
            id: diskProc
            command: ["bash", "-c", "df / | awk 'NR==2 {gsub(/%/,\"\"); print $5}'"]
            stdout: SplitParser {
                onRead: data => dashboard.diskVal = parseInt(data) || 0
            }
        }

        Process {
            id: batProc
            command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100"]
            stdout: SplitParser {
                onRead: data => {
                    dashboard.batVal = parseInt(data) || 100
                    var cap = dashboard.batVal
                    if (cap >= 90) batIcon.text = "󰁹"
                    else if (cap >= 80) batIcon.text = "󰂂"
                    else if (cap >= 70) batIcon.text = "󰂁"
                    else if (cap >= 60) batIcon.text = "󰂀"
                    else if (cap >= 50) batIcon.text = "󰁿"
                    else if (cap >= 40) batIcon.text = "󰁾"
                    else if (cap >= 30) batIcon.text = "󰁽"
                    else if (cap >= 20) batIcon.text = "󰁼"
                    else if (cap >= 10) batIcon.text = "󰁻"
                    else batIcon.text = "󰁺"
                }
            }
        }

        Process {
            id: batStatusProc
            command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Unknown"]
            stdout: SplitParser {
                onRead: data => {
                    var status = data.trim()
                    if (status === "Charging") {
                        batStatus.text = "Charging"
                        batIcon.text = "󰂄"
                    } else if (status === "Full") {
                        batStatus.text = "Fully charged"
                    } else {
                        batStatus.text = "Discharging"
                    }
                }
            }
        }

        Process {
            id: volProc
            command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"%.0f\", $2*100}'"]
            stdout: SplitParser {
                onRead: data => dashboard.volVal = parseInt(data) || 0
            }
        }

        Process {
            id: brightProc
            command: ["bash", "-c", "brightnessctl -m | awk -F, '{gsub(/%/,\"\"); print $4}'"]
            stdout: SplitParser {
                onRead: data => dashboard.brightVal = parseInt(data) || 100
            }
        }

        Process {
            id: uptimeProc
            command: ["bash", "-c", "uptime -p"]
            stdout: SplitParser {
                onRead: data => uptimeText.text = data.trim()
            }
        }
    }

    IpcHandler {
        target: "dashboard"

        function toggle(): void {
            root.dashboardVisible = !root.dashboardVisible
        }

        function show(): void {
            root.dashboardVisible = true
        }

        function hide(): void {
            root.dashboardVisible = false
        }
    }

    PanelWindow {
        id: musicPanel

        visible: true
        exclusionMode: ExclusionMode.Ignore

        anchors {
            top: true
            left: true
            right: true
        }

        margins {
            top: root.musicVisible ? 50 : -230
            left: 0
            right: 0
        }

        implicitWidth: 400
        implicitHeight: 180
        color: "transparent"

        Behavior on margins.top {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: 400
            height: 180
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
                    spacing: 6

                    Text {
                        text: musicPanel.trackTitle || "Nothing is playing"
                        color: "#D9C7A9"
                        font.pixelSize: 15
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: musicPanel.trackArtist || ""
                        color: "#e5e5de"
                        font.pixelSize: 12
                        font.family: "JetBrainsMono Nerd Font"
                        opacity: 0.7
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        visible: musicPanel.trackArtist !== ""
                    }

                    Item { Layout.fillHeight: true }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        visible: musicPanel.hasTrack

                        Text {
                            text: musicPanel.formatTime(musicPanel.position)
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
                                width: musicPanel.length > 0 
                                    ? parent.width * (musicPanel.position / musicPanel.length) 
                                    : 0
                                height: parent.height
                                radius: 2
                                color: "#D9C7A9"

                                Behavior on width {
                                    NumberAnimation { duration: 200 }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: function(mouse) {
                                    if (musicPanel.length > 0) {
                                        var seekPos = (mouse.x / parent.width) * musicPanel.length
                                        seekProc.command = ["bash", "-c", "playerctl position " + seekPos]
                                        seekProc.running = true
                                    }
                                }
                            }
                        }

                        Text {
                            text: musicPanel.formatTime(musicPanel.length)
                            color: "#a0a09b"
                            font.pixelSize: 10
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 12
                        opacity: musicPanel.hasTrack ? 1.0 : 0.5

                        Rectangle {
                            width: 32
                            height: 32
                            radius: 8
                            color: prevMa.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "󰒮"
                                color: "#e5e5de"
                                font.pixelSize: 16
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            MouseArea {
                                id: prevMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: prevProc.running = true
                            }
                        }

                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: "#D9C7A9"

                            Text {
                                anchors.centerIn: parent
                                text: musicPanel.playerStatus === "Playing" ? "󰏤" : "󰐊"
                                color: "#101219"
                                font.pixelSize: 18
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: playPauseProc.running = true
                            }
                        }

                        Rectangle {
                            width: 32
                            height: 32
                            radius: 8
                            color: nextMa.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent"

                            Text {
                                anchors.centerIn: parent
                                text: "󰒭"
                                color: "#e5e5de"
                                font.pixelSize: 16
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            MouseArea {
                                id: nextMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: nextProc.running = true
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 160
                    Layout.alignment: Qt.AlignBottom

                    AnimatedImage {
                        id: honeypieImage
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -20
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        width: 270
                        height: 182
                        
                        source: "file:///home/harman/.config/quickshell/assets/honeypie.gif"
                        
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        
                        playing: musicPanel.playerStatus === "Playing"
                        paused: musicPanel.playerStatus !== "Playing"
                    }
                }
            }
        }

        property string playerStatus: "Stopped"
        property string trackTitle: ""
        property string trackArtist: ""
        property real position: 0
        property real lastPosition: 0
        property real length: 0
        property bool hasTrack: playerStatus === "Playing" || playerStatus === "Paused"

        function formatTime(seconds) {
            var mins = Math.floor(seconds / 60)
            var secs = Math.floor(seconds % 60)
            return mins + ":" + (secs < 10 ? "0" : "") + secs
        }

        Timer {
            interval: 500
            running: root.musicVisible
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                musicStatusProc.running = true
            }
        }

        Process {
            id: musicStatusProc
            command: ["bash", "-c", "playerctl status 2>/dev/null || echo 'Stopped'"]
            stdout: SplitParser {
                onRead: data => {
                    var newStatus = data.trim()
                    var wasPlaying = musicPanel.playerStatus === "Playing"
                    var isNowPlaying = newStatus === "Playing"
                    
                    musicPanel.playerStatus = newStatus
                    musicTitleProc.running = true
                    musicArtistProc.running = true
                    musicLenProc.running = true
                    
                    if (isNowPlaying) {
                        musicPosProc.running = true
                    } else if (wasPlaying && !isNowPlaying) {
                        musicPanel.lastPosition = musicPanel.position
                    } else if (!isNowPlaying) {
                        musicPanel.position = musicPanel.lastPosition
                    }
                }
            }
        }

        Process {
            id: musicTitleProc
            command: ["bash", "-c", "playerctl metadata title 2>/dev/null || echo ''"]
            stdout: SplitParser {
                onRead: data => musicPanel.trackTitle = data.trim()
            }
        }

        Process {
            id: musicArtistProc
            command: ["bash", "-c", "playerctl metadata artist 2>/dev/null || echo ''"]
            stdout: SplitParser {
                onRead: data => musicPanel.trackArtist = data.trim()
            }
        }

        Process {
            id: musicPosProc
            command: ["bash", "-c", "playerctl position 2>/dev/null || echo '0'"]
            stdout: SplitParser {
                onRead: data => {
                    var pos = parseFloat(data.trim()) || 0
                    musicPanel.position = pos
                    musicPanel.lastPosition = pos
                }
            }
        }

        Process {
            id: musicLenProc
            command: ["bash", "-c", "playerctl metadata mpris:length 2>/dev/null | awk '{print $1/1000000}'"]
            stdout: SplitParser {
                onRead: data => musicPanel.length = parseFloat(data.trim()) || 0
            }
        }

        Process {
            id: playPauseProc
            command: ["bash", "-c", "playerctl play-pause"]
            onExited: {
                musicStatusProc.running = true
            }
        }

        Process {
            id: nextProc
            command: ["bash", "-c", "playerctl next"]
            onExited: {
                musicStatusProc.running = true
            }
        }

        Process {
            id: prevProc
            command: ["bash", "-c", "playerctl previous"]
            onExited: {
                musicStatusProc.running = true
            }
        }

        Process {
            id: seekProc
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