#!/bin/bash

COLORS_FILE="$HOME/.cache/wal/colors"
OUTPUT="$HOME/.config/quickshell/Colors.qml"

if [ ! -f "$COLORS_FILE" ]; then
    echo "PyWal colors not found. Run 'wal -i <wallpaper>' first."
    exit 1
fi

# Read colors into array
mapfile -t colors < "$COLORS_FILE"

cat > "$OUTPUT" << EOF
pragma Singleton
import QtQuick

QtObject {
    readonly property color bg: "${colors[0]}"
    readonly property color fg: "${colors[7]}"
    readonly property color color0: "${colors[0]}"
    readonly property color color1: "${colors[1]}"
    readonly property color color2: "${colors[2]}"
    readonly property color color3: "${colors[3]}"
    readonly property color color4: "${colors[4]}"
    readonly property color color5: "${colors[5]}"
    readonly property color color6: "${colors[6]}"
    readonly property color color7: "${colors[7]}"
    readonly property color color8: "${colors[8]}"

    readonly property color accent: "${colors[4]}"
    readonly property color accentAlt: "${colors[5]}"
    readonly property color textPrimary: "${colors[7]}"
    readonly property color textSecondary: "${colors[7]}"
    readonly property color bgDark: Qt.rgba(0, 0, 0, 0.4)
    readonly property color bgLight: Qt.rgba(1, 1, 1, 0.1)
}
EOF

echo "Colors.qml updated with PyWal colors!"
