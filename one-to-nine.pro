TEMPLATE = app
TARGET = one-to-nine

QT += qml quick quickcontrols2

SOURCES += main.cpp
SOURCES += Cell.cpp Field.cpp
HEADERS += Cell.hpp Field.hpp

RESOURCES += qml.qrc

OTHER_FILES = \
    qml/CellItem.qml \
    qml/main.qml

OTHER_FILES = \
    rpm/one-to-nine.spec

# Installation directories
isEmpty(INSTALL_PREFIX) {
    unix {
        INSTALL_PREFIX = /usr/local
    } else {
        INSTALL_PREFIX = $$[QT_INSTALL_PREFIX]
    }
}

isEmpty(INSTALL_BIN_DIR) {
    INSTALL_BIN_DIR = $$INSTALL_PREFIX/bin
}

target.path = $$INSTALL_BIN_DIR

# Default rules for deployment.
!isEmpty(target.path): INSTALLS += target
