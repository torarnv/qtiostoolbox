TEMPLATE = lib
CONFIG += shared framework lib_bundle
CONFIG -= qt_no_framework static staticlib

TARGET = Qt
VERSION = $$QT_VERSION

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

QT = core gui
QTPLUGIN = ios iosmain

unset(LIBS)
unset(INCLUDEPATH)
load(qt)

unset(path)
for(lib, LIBS) {
    contains(lib, ^-L.*) {
        path = $$replace(lib, ^-L, )
        next()
    }
    contains(lib, ^-l.*) {
        # We can't put these into OBJECTS, as 'make clean' would then delete
        # the Qt libraries and plugins.
        QMAKE_LFLAGS += $$path/lib$$replace(lib, ^-l, ).a
        next()
    }
}
unset(LIBS)
unset(LIBS_PRIVATE)

unset(includes)
for(path, INCLUDEPATH) {
    equals(path, $$[QT_INSTALL_HEADERS]): next()
    includes += $$path #$$files($$path/*)
}

HEADERS += $$includes

FRAMEWORK_HEADERS.version = Versions
FRAMEWORK_HEADERS.files = $$includes
FRAMEWORK_HEADERS.path = Headers
QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS

QMAKE_INFO_PLIST = Info.plist

