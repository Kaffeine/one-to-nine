#include "Field.hpp"

#include "Cell.hpp"

#include <QDebug>

const int c_width = 9;
const int c_height = 9;

Field::Field() :
    QObject()
{
    m_state = StateIdle;
    m_resetInProgress = true;

//    for (Cell *cell : m_cells) {
//        delete cell;
//    }
//    m_cells.clear();

    for (int y = 0; y < 9; ++y) {
        for (int x = 0; x < 9; ++x) {
            Cell *cell = new Cell();
            //cell->setDigit();
            m_cells.append(cell);
//            connect(cell, &Cell::digitChanged, this, [=]() {
//                onCellDigitChanged(x, y);
//            });
            connect(cell, &Cell::digitChanged, this, &Field::onCellDigitChanged);
        }
    }
    // level 1
    QVector<int> predefined =
    {
        0, 0, 4,  0, 8, 0,  3, 0, 0,
        0, 0, 0,  0, 0, 3,  0, 4, 2,
        8, 0, 0,  4, 0, 5,  9, 0, 7,

        3, 0, 2,  0, 7, 0,  5, 0, 8,
        0, 5, 0,  0, 0, 0,  0, 7, 0,
        6, 0, 8,  0, 9, 0,  2, 0, 1,

        4, 0, 6,  2, 0, 7,  0, 0, 9,
        5, 2, 0,  9, 0, 0,  0, 0, 0,
        0, 0, 7,  0, 1, 0,  4, 0, 0,
    };

//    QVector<int> predefined =
//    {
//        0, 0, 0,  0, 0, 0,  0, 0, 0,
//        0, 0, 0,  0, 0, 0,  0, 0, 0,
//        0, 0, 0,  0, 0, 0,  0, 0, 0,

//        0, 0, 0,  0, 0, 0,  0, 0, 0,
//        0, 0, 0,  0, 0, 0,  0, 0, 0,
//        0, 0, 0,  0, 0, 0,  0, 0, 0,

//        0, 0, 0,  0, 0, 0,  0, 0, 0,
//        0, 0, 0,  0, 0, 0,  0, 0, 0,
//        0, 0, 0,  0, 0, 0,  0, 0, 0,
//    };
//    QVector<int> predefined =
//    {
//        0, 0, 0,  0, 9, 7,  0, 0, 6,
//        5, 0, 0,  2, 0, 0,  1, 0, 4,
//        3, 0, 0,  0, 0, 1,  0, 7, 0,

//        0, 9, 3,  8, 0, 5,  0, 0, 7,
//        0, 0, 0,  0, 1, 0,  0, 0, 0,
//        4, 0, 0,  7, 0, 6,  5, 9, 0,

//        0, 4, 0,  1, 0, 0,  0, 0, 9,
//        8, 0, 2,  0, 0, 9,  0, 0, 1,
//        9, 0, 0,  6, 4, 0,  0, 0, 0,
//    };

    for (int i = 0; i < predefined.count(); ++i) {
        m_cells.at(i)->setPredefinedDigit(predefined.at(i));
    }
}

void Field::startNewGame()
{
    setState(StateIdle);
//    m_generated = false;

//    for (Cell *cell : m_cells) {
//        cell->reset();

//        QVector<Cell*> neighbors;
//        for (int x = cell->x() - 1; x <= cell->x() + 1; ++x) {
//            maybeAddCell(&neighbors, cellAt(x, cell->y() - 1));
//            maybeAddCell(&neighbors, cellAt(x, cell->y() + 1));
//        }
//        maybeAddCell(&neighbors, cellAt(cell->x() - 1, cell->y()));
//        maybeAddCell(&neighbors, cellAt(cell->x() + 1, cell->y()));

//        cell->setNeighbors(neighbors);
//    }

//    m_numberOfFlags = 0;
//    emit numberOfFlagsChanged(m_numberOfFlags);

//    m_numberOfOpenCells = 0;
}

void Field::generate()
{
//    m_generated = true;


    setState(StateStarted);
}

Cell *Field::cellAt(int x, int y) const
{
    if (x < 0 || x >= c_width) {
        return nullptr;
    }
    if (y < 0 || y >= c_height) {
        return nullptr;
    }

    return m_cells.at(x + y * c_width);
}

//void Field::onCellDigitChanged(int x, int y)
//{
//}

void Field::onCellDigitChanged()
{
    // Check rows
    for (int y = 0; y < 9; ++y) {
        QVector<int> digits;
        for (int x = 0; x < 9; ++x) {
            digits.append(cellAt(x, y)->digit());
        }
        std::sort(digits.begin(), digits.end());
        if ((digits.first() != 1) || (digits.last() != 9)) {
            return;
        }
    }
    // Check columns
    for (int x = 0; x < 9; ++x) {
        QVector<int> digits;
        for (int y = 0; y < 9; ++y) {
            digits.append(cellAt(x, y)->digit());
        }
        std::sort(digits.begin(), digits.end());
        if ((digits.first() != 1) || (digits.last() != 9)) {
            return;
        }
    }
    // Check squares
    for (int n = 0; n < 9; ++n) {
        QVector<int> digits;
        int xOff = (n % 3) * 3;
        int yOff = (n / 3) * 3;
        for (int x = 0; x < 3; ++x) {
            for (int y = 0; y < 3; ++y) {
                qDebug() << n << "get cell at" << (x + xOff) << (y + yOff);
                digits.append(cellAt(x + xOff, y + yOff)->digit());
            }
        }
        std::sort(digits.begin(), digits.end());
        if ((digits.first() != 1) || (digits.last() != 9)) {
            return;
        }
    }
    win();
}

void Field::win()
{
    setState(StateEnded);
}

void Field::setState(Field::State newState)
{
    if (m_state == newState) {
        return;
    }

    m_state = newState;
    emit stateChanged();
}

void Field::setResetInProgress(bool reset)
{
    if (m_resetInProgress == reset) {
        return;
    }

    m_resetInProgress = reset;
    emit resetInProgressChanged(reset);
}
