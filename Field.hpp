#ifndef FIELD_HPP
#define FIELD_HPP

#include <QObject>
#include <QVector>

class Cell;

class Field : public QObject
{
    Q_OBJECT
    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(bool resetInProgress READ resetInProgress NOTIFY resetInProgressChanged)
public:
    enum State {
        StateIdle,
        StateStarted,
        StateEnded
    };
    Q_ENUM(State)

    Field();

    State state() const { return m_state; }
    bool resetInProgress() const { return m_resetInProgress; }

    void generate();

    Q_INVOKABLE Cell *cellAt(int x, int y) const;

signals:
    void numberOfFlagsChanged(int number);
    void stateChanged();
    void resetInProgressChanged(bool reset);

    void widthChanged(int newWidth);
    void heightChanged(int newHeight);

public slots:
    void startNewGame();

protected slots:
//    void onCellDigitChanged(int x, int y);
    void onCellDigitChanged();

private:
    void setState(State newState);
    void setResetInProgress(bool reset);

    void lose();
    void win();

    QVector<Cell*> m_cells;

    State m_state;

    bool m_resetInProgress;
};

#endif // FIELD_HPP
