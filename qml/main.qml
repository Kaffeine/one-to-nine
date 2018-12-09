import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import GameComponents 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 420
    height: 640
    title: qsTr("One to Nine")

    header: ToolBar {
        ToolButton {
            text: "<"
        }
    }

    property int inset: width / 11
    property int draftCode: -1

    QtObject {
        id: settings
        property color backgroundColor: Material.color(Material.background, Material.Shade50)
        property color backgroundAlternativeColor: Material.color(Material.background, Material.Shade100)

        property color highlight: Material.color(Material.accent, Material.Shade300)
        property color secondaryHighlight: Material.color(Material.accent, Material.Shade50)

        property color highlightedDigitBackgroundColor: Material.color(Material.background, Material.Shade200)

        property color highlightCellColor: Material.color(Material.Blue, Material.Shade100)
        property color strongHighlightCellColor: Material.color(Material.Blue, Material.Shade300)

        property color borderColor: "black" //Material.color(Material.accent)
    }

    Rectangle {
        color: Material.color(Material.Green)
        anchors.fill: parent
        opacity: field.state == Field.StateEnded
    }

    Pane {
        id: board
        anchors.left: parent.left
        anchors.leftMargin: inset
        anchors.right: parent.right
        anchors.rightMargin: inset
        y: inset
        height: width
        Material.elevation: 6

        property var activeCell: field.cellAt(board.activeCellX, board.activeCellY)
        property bool canDraw: board.activeCell && !board.activeCell.predefined

        property int activeCellX: -1
        property int activeCellY: -1

        property int highlightedDigit: activeCell ? activeCell.digit : 0
        property bool draftMode: false

        Item {
            id: cellContainer
            anchors.fill: parent
            anchors.margins: 10
            property real windowProportion: width / height
            property real fieldProportion: field.width * 1.0 / field.height
            property real fixupFactor: windowProportion > fieldProportion ? 1 : windowProportion / fieldProportion
            property int preferredSize: height / field.height * fixupFactor


            Rectangle {
                border.width: 2
                border.color: settings.borderColor
                anchors.fill: parent
                color: "transparent"
            }

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
//                            if (cell.predefined) {

//                            }

                            board.activeCellX = logicalX
                            board.activeCellY = logicalY
                        }
                    }
                }
            }
        }
    }

    Pane {
        id: alphabet
        enabled: board.canDraw
        anchors.top: board.bottom
        anchors.topMargin: inset
        anchors.horizontalCenter: parent.horizontalCenter
        Material.elevation: 3
        Grid {
            columns: 5
            spacing: 2
            Repeater {
                model: 10
                Button {
                    property bool draft: digit == 10
                    visible: !draft
                    flat: true
                    down: board.canDraw && digit == board.highlightedDigit
                    checkable: draft
                    property int digit: index + 1

                    text: draft ? "" : digit
                    //icon.source: draft ? "qrc:/draw-calligraphic.svg" : ""
                    onClicked: {
                        if (draft) {
                            board.draftMode = checked
                            return
                        }
                        if (board.activeCell) {
                            if (board.activeCell.digit == digit) {
                                board.activeCell.digit = 0
                            } else {
                                board.activeCell.digit = digit
                            }
                        }
                    }
                }
            }
        }
    }

    Field {
        id: field
        property int width: 9
        property int height: 9
    }
}
