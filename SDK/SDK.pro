TEMPLATE = aux

isEmpty(QMAKE_SDK_NAME): QMAKE_SDK_NAME = iphoneos # FIME: Get from qmake

SDKDIR = $${QMAKE_SDK_NAME}.sdk
DESTDIR = $$SDKDIR/usr

SDKSETTINGS = SDKSettings.plist
sdksettings.input = SDKSETTINGS
sdksettings.output = $${SDKDIR}/${QMAKE_FILE_IN_BASE}.plist
sdksettings.commands = sed s/@QMAKE_SDK_NAME@/$${QMAKE_SDK_NAME}/ ${QMAKE_FILE_IN} > ${QMAKE_FILE_OUT}
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

defineReplace(finalPath) {
    return($$DESTDIR/$$replace(1, $$relative_path($$[QT_INSTALL_PREFIX/get]), ))
}

libs.input = LIB_PATHS
libs.output_function = finalPath
libs.commands = ln -f -s ${QMAKE_FILE_IN} ${QMAKE_FILE_OUT}
libs.CONFIG = no_link target_predeps
QMAKE_EXTRA_COMPILERS += libs

qt_includes = $$INCLUDEPATH
qt_includes -= $$[QT_INSTALL_HEADERS/get]
headers.input = qt_includes
headers.output_function = finalPath
headers.commands = ln -F -s ${QMAKE_FILE_IN} ${QMAKE_FILE_OUT}
headers.CONFIG = no_link target_predeps
QMAKE_EXTRA_COMPILERS += headers

