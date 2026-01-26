import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".."

Rectangle {
    color: Colors.bgDark
    radius: 15

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        // Time display
        Text {
            id: timeText
            text: Qt.formatTime(new Date(), "hh:mm:ss")
            color: Colors.accent
            font.pixelSize: 42
            font.family: "JetBrainsMono Nerd Font"
            Layout.alignment: Qt.AlignHCenter

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm:ss")
            }
        }

        // Date display
        Text {
            text: Qt.formatDate(new Date(), "dd.MM.yyyy, dddd")
            color: Colors.textPrimary
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font"
            Layout.alignment: Qt.AlignHCenter
        }

        // Calendar grid
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Qt.rgba(0, 0, 0, 0.2)
            radius: 10

            GridLayout {
                anchors.fill: parent
                anchors.margins: 10
                columns: 7
                rowSpacing: 5
                columnSpacing: 5

                // Day headers
                Repeater {
                    model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                    Text {
                        text: modelData
                        color: Colors.color3
                        font.pixelSize: 11
                        font.family: "JetBrainsMono Nerd Font"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }

                // Calendar days
                Repeater {
                    model: calendarModel

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 25
                        radius: 5
                        color: modelData.isToday ? Colors.accent : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData.day > 0 ? modelData.day : ""
                            color: modelData.isToday ? Colors.bg :
                                   modelData.isCurrentMonth ? Colors.textPrimary :
                                   Qt.rgba(Colors.textPrimary.r, Colors.textPrimary.g, Colors.textPrimary.b, 0.3)
                            font.pixelSize: 11
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }
                }
            }
        }
    }

    property var calendarModel: {
        var model = []
        var today = new Date()
        var year = today.getFullYear()
        var month = today.getMonth()

        var firstDay = new Date(year, month, 1)
        var lastDay = new Date(year, month + 1, 0)
        var startDay = firstDay.getDay()

        // Previous month days
        var prevMonthDays = new Date(year, month, 0).getDate()
        for (var i = startDay - 1; i >= 0; i--) {
            model.push({ day: prevMonthDays - i, isCurrentMonth: false, isToday: false })
        }

        // Current month days
        for (var d = 1; d <= lastDay.getDate(); d++) {
            model.push({
                day: d,
                isCurrentMonth: true,
                isToday: d === today.getDate()
            })
        }

        // Next month days
        var remaining = 42 - model.length
        for (var n = 1; n <= remaining; n++) {
            model.push({ day: n, isCurrentMonth: false, isToday: false })
        }

        return model
    }
}
