import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    property string label: "STAT"
    property string icon: ""
    property int value: 0
    property color color: Colors.accent

    spacing: 10

    Text {
        text: icon
        color: color
        font.pixelSize: 18
        font.family: "JetBrainsMono Nerd Font"
        Layout.preferredWidth: 25
    }

    Text {
        text: label
        color: Colors.textPrimary
        font.pixelSize: 12
        font.family: "JetBrainsMono Nerd Font"
        Layout.preferredWidth: 40
    }

    Rectangle {
        Layout.fillWidth: true
        height: 8
        radius: 4
        color: Qt.rgba(0, 0, 0, 0.3)

        Rectangle {
            width: parent.width * (value / 100)
            height: parent.height
            radius: 4
            color: color

            Behavior on width {
                NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
            }
        }
    }

    Text {
        text: value + "%"
        color: Colors.textSecondary
        font.pixelSize: 11
        font.family: "JetBrainsMono Nerd Font"
        Layout.preferredWidth: 35
        horizontalAlignment: Text.AlignRight
    }
}
