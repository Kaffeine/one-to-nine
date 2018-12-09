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
        Label {
            anchors.centerIn: parent
            text: {
                var seconds = gameTimer.seconds % 60
                var minutes = Math.floor(gameTimer.seconds / 60)
                if (seconds < 10) {
                    seconds = "0" + seconds
                }

                return minutes + ":" + seconds
            }
        }
    }

    property int inset: width / 11
    property int draftCode: -1

    Timer {
        id: gameTimer
        property int seconds: 0
        interval: 1000
        repeat: true
        running: !gameFinished
        onTriggered: {
            ++seconds
        }
    }

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
        visible: gameFinished
    }

    property bool gameFinished: field.state == Field.StateEnded

    Pane {
        id: boardPane
        anchors.left: parent.left
        anchors.leftMargin: inset
        anchors.right: parent.right
        anchors.rightMargin: inset
        y: inset
        height: width
        Material.elevation: 6

        BoardItem {
            id: board
            anchors.fill: parent
            anchors.margins: 10

            property var activeCell: field.cellAt(board.activeCellX, board.activeCellY)
            property bool canDraw: board.activeCell && !board.activeCell.predefined

            property int activeCellX: -1
            property int activeCellY: -1

            property int highlightedDigit: activeCell ? activeCell.digit : 0
            property bool draftMode: false
        }
    }

    Pane {
        id: alphabet
        enabled: board.canDraw
        anchors.top: boardPane.bottom
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
