import QtQuick 2.9
import QtQuick.Controls.Material 2.2

import GameComponents 1.0

Item {
    id: cellItem
    width: size
    height: size

    property Cell cell: null

    property int highlighted: 0

    property int size: 64

    property int rectMargin: (size * 0.12) < 2 ? 2 : size * 0.12

    property int bigX: logicalX / 3
    property int bigY: logicalY / 3
    property int logicalX
    property int logicalY

    Rectangle {
        property bool alternate: (bigX + bigY * 3) % 2
        color: {
            if (highlighted == 1) {
                return settings.highlightCellColor
            }
            if (highlighted == 2) {
                return settings.strongHighlightCellColor
            }

            if (board.highlightedDigit && (board.highlightedDigit == cell.digit)) {
                return settings.highlightedDigitBackgroundColor
            }

            if (alternate) {
                return settings.backgroundColor
            } else {
                return settings.backgroundAlternativeColor
            }
        }

        visible: true
        anchors.fill: parent
        border.width: 1
        border.color: settings.borderColor
    }

    Text {
        anchors.centerIn: parent
        text: cell.digit ? cell.digit : ""
        font.pixelSize: cellItem.size * 0.6
        color: cell.predefined ? Material.foreground : Material.primary
    }

    signal clicked(int x, int y)

    MouseArea {
        acceptedButtons: Qt.LeftButton
        anchors.fill: parent

        onClicked: cellItem.clicked(cellItem.logicalX, cellItem.logicalY)
    }
}
