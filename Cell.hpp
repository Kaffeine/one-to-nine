#ifndef CELL_HPP
#define CELL_HPP

#include <QObject>
#include <QVector>

class Cell : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int digit READ digit WRITE setDigit NOTIFY digitChanged)
    Q_PROPERTY(bool predefined READ isPredefined NOTIFY predefinedChanged)
    Q_PROPERTY(QVector<int> draftDigits READ draftDigits WRITE setDraftDigits NOTIFY draftDigitsChanged)
public:
    Cell();

    void reset();

    int digit() const { return m_digit; }
    bool isPredefined() const { return m_predefined; }
    QVector<int> draftDigits() const { return m_draftDigits; }

    void setPredefinedDigit(int digit);
    void setDigitInternal(int digit);

public slots:
    void setDigit(int digit);
    void addDraftDigit(int digit);
    void setDraftDigits(const QVector<int> draftDigits);

signals:
    void digitChanged(int digit);
    void predefinedChanged(bool predefined);
    void draftDigitsChanged();

private:
    QVector<int> m_draftDigits;
    int m_digit = 0;
    bool m_predefined = false;
};

#endif // CELL_HPP

