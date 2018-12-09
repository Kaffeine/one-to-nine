import QtQuick 2.9

Item {
    id: cellContainer
    property real windowProportion: width / height
    property real fixupFactor: windowProportion > 1 ? 1 : windowProportion / 1
    property int preferredSize: height / field.height * fixupFactor

    Rectangle {
        border.width: 2
        border.color: settings.borderColor
        anchors.fill: parent
        color: "transparent"
        Rectangle {
            width: parent.width
            height: 2
            color: settings.borderColor
            y: cellContainer.preferredSize * 3
        }
        Rectangle {
            width: parent.width
            height: 2
            color: settings.borderColor
            y: cellContainer.preferredSize * 6
        }
        Rectangle {
            height: parent.height
            width: 2
            color: settings.borderColor
            x: cellContainer.preferredSize * 3
        }
        Rectangle {
            height: parent.height
            width: 2
            color: settings.borderColor
            x: cellContainer.preferredSize * 6
        }
    }

    Grid {
        id: fieldItem
        anchors.centerIn: parent

        columns: 9
        Repeater {
            id: cellRepeater
            model: 9 * 9

            CellItem {
                logicalX: index % 9
                logicalY: index / 9
                cell: field.cellAt(logicalX, logicalY)
                size: cellContainer.preferredSize
                highlighted: {
                    var match = 0
                    if (board.activeCellX == logicalX) {
                        match += 1
                    }
                    if (board.activeCellY == logicalY) {
                        match += 1
                    }
                    return match
                }

                onClicked: {
                    board.activeCellX = logicalX
                    board.activeCellY = logicalY
                }
            }
        }
    }
}
