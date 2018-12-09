#include "Cell.hpp"

Cell::Cell() :
    QObject()
{
}

void Cell::reset()
{
}

void Cell::setPredefinedDigit(int digit)
{
    setDigit(digit);
    m_predefined = digit > 0;
    emit predefinedChanged(m_predefined);
}

void Cell::setDigitInternal(int digit)
{
    if (m_digit == digit) {
        return;
    }
    m_digit = digit;
    emit digitChanged(digit);
}

void Cell::setDigit(int digit)
{
    if (m_predefined) {
        return;
    }
    setDigitInternal(digit);
}

void Cell::addDraftDigit(int digit)
{

}

void Cell::setDraftDigits(const QVector<int> draftDigits)
{

}
