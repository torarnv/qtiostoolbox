TEMPLATE = aux

load(sdk)
isEmpty(QMAKE_MAC_PLATFORM_NAME): QMAKE_MAC_PLATFORM_NAME = iphoneos

SDKDIR = $${QMAKE_MAC_PLATFORM_NAME}.sdk
DESTDIR = $$SDKDIR/usr

SDKSETTINGS = SDKSettings.plist
sdksettings.input = SDKSETTINGS
sdksettings.output = $${SDKDIR}/${QMAKE_FILE_IN_BASE}.plist
sdksettings.commands = sed s/@QMAKE_MAC_PLATFORM_NAME@/$${QMAKE_MAC_PLATFORM_NAME}/ ${QMAKE_FILE_IN} > ${QMAKE_FILE_OUT}
sdksettings.CONFIG = no_link target_predeps
QMAKE_EXTRA_COMPILERS += sdksettings

QT = core gui network platformsupport
QTPLUGIN = ios iosmain

unset(LIBS)
unset(INCLUDEPATH)
load(qt)

unset(LIB_PATHS)
unset(path)
for(lib, LIBS) {
    contains(lib, ^-L.*) {
        path = $$replace(lib, ^-L, )
        next()
    }
    contains(lib, ^-l.*) {
        lib = $$replace(lib, ^-l, )
        LIB_PATHS += $$absolute_path($$path/lib$${lib}.a)
        next()
    }
}

defineReplace(ABS_FILE_IN) {
    return($$absolute_path($$1, $$OUT_PWD))
}

defineReplace(outputFunction) {
    path = $$absolute_path($$1, $$OUT_PWD)
    return($$DESTDIR/$$replace(path, $$[QT_INSTALL_PREFIX/get], ))
}

libs.input = LIB_PATHS
libs.output_function = outputFunction
libs.commands = ln -f -s ${QMAKE_FUNC_ABS_FILE_IN} ${QMAKE_FILE_OUT}
libs.CONFIG = no_link target_predeps
QMAKE_EXTRA_COMPILERS += libs

qt_includes = $$INCLUDEPATH
qt_includes -= $$[QT_INSTALL_HEADERS/get]
headers.input = qt_includes
headers.output_function = outputFunction
headers.commands = ln -F -s ${QMAKE_FUNC_ABS_FILE_IN} ${QMAKE_FILE_OUT}
headers.CONFIG = no_link target_predeps
QMAKE_EXTRA_COMPILERS += headers

