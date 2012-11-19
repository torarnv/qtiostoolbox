TEMPLATE = lib
CONFIG += shared framework lib_bundle
CONFIG -= qt_no_framework static staticlib

TARGET = Qt

QMAKE_SDK_NAME = iphoneos # FIME: Get from qmake

SDKDIR = $${QMAKE_SDK_NAME}.sdk
DESTDIR = $$SDKDIR/System/Library/Frameworks

SDKSETTINGS = SDKSettings.plist
sdksettings.input = SDKSETTINGS
sdksettings.output = $${SDKDIR}/${QMAKE_FILE_IN_BASE}.plist
sdksettings.commands = sed s/@QMAKE_SDK_NAME@/$${QMAKE_SDK_NAME}/ ${QMAKE_FILE_IN} > ${QMAKE_FILE_OUT}
sdksettings.CONFIG = no_link target_predeps
QMAKE_EXTRA_COMPILERS += sdksettings

QMAKE_LINK = libtool -static

load(sdk)
unset(QMAKE_LFLAGS_SHLIB)
unset(QMAKE_LFLAGS_COMPAT_VERSION)
unset(QMAKE_LFLAGS_SONAME)
unset(QMAKE_LFLAGS_VERSION)
unset(QMAKE_LFLAGS)
unset(QMAKE_LIBS_OPENGL_ES2)

QT += gui widgets printsupport core
QTPLUGIN += qtmain

load(qt)

# FIXME: Transform into libtool arguments
message(LIBS = $$LIBS)

unset(LIBS)
unset(LIBS_PRIVATE)
