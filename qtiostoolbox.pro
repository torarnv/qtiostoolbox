TEMPLATE = aux

PODSPEC_FILE = $$OUT_PWD/Qt.podspec

QT_DESCRIPTION  = "Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language."
QT_HOMEPAGE     = "http://qt-project.org/"
QT_AUTHORS      = "The Qt Project"
QT_LICENSE      = "LGPL"

PODSPEC += "Pod::Spec.new do |s|" \
    "  s.name       = 'Qt'" \
    "  s.version    = '$$QT_VERSION'" \
    "  s.summary    = '$$QT_DESCRIPTION'" \
    "  s.homepage   = '$$QT_HOMEPAGE'" \
    "  s.author     = '$$QT_AUTHORS'" \
    "  s.license    = '$$QT_LICENSE'"

PODSPEC += \
    "  s.source         = { :git => 'https://github.com/torarnv/qtiostoolbox.git' }" \
    "  s.platform       = :ios" \
    "  s.source_files   = 'QtQuickView'"

defineTest(parseLibs) {
    var = $$1
    libFunc = $$2

    unset(path)
    unset(framework)
    for(lib, $$1) {
        equals(lib, -framework) {
            framework = true
            next()
        } else:contains(lib, ^-L.*) {
            path = $$replace(lib, ^-L, )
        } else:contains(lib, ^-l.*) {
            lib = $$replace(lib, ^-l, )
            eval($${libFunc}($$path, $$lib))
        } else:equals(framework, true) {
            frameworks += "'$$lib'"
        }

        unset(framework)
    }

    export(libs)
    export(frameworks)
}

# ------ Platform plugin -------

unset(QT)
unset(LIBS)
QTPLUGIN = ios
load(qt)

name = QtPlatformPlugin
PODSPEC += "  s.subspec '$$name' do |platformplugin|"

defineTest(addLibsAndDepends) {
    # We let the podspec take care of dependencies to other Qt libs
    contains(2, ^Qt.*): depends += $$replace(2, ^Qt$${QT_MAJOR_VERSION}, Qt)
    else: libs += "'$$2'"
    export(libs)
    export(depends)
}

defineTest(addPluginAndRecursePrl) {
    ldflags = "-force_load $(SDKROOT)/usr/plugins/platforms/lib$${2}.a"
    prl_file = $$1/lib$${2}.prl
    exists($$prl_file) {
        prl_libs = $$fromfile($$prl_file, QMAKE_PRL_LIBS)
        parseLibs(prl_libs, addLibsAndDepends)
    }
    export(libs)
    export(ldflags)
}
unset(libs)
unset(frameworks)
unset(depends)
message($$LIBS)
parseLibs(LIBS, addPluginAndRecursePrl)

PODSPEC += "    platformplugin.xcconfig = { 'OTHER_LDFLAGS' => '$$ldflags' }"
PODSPEC += "    platformplugin.libraries = $$join(libs, ', ')"
PODSPEC += "    platformplugin.frameworks = $$join(frameworks, ', ')"

for(dep, depends) {
    PODSPEC += "    platformplugin.dependency 'Qt/$$dep'"
}

PODSPEC += "  end"

QT.gui.depends += platformplugin
QT.platformplugin.name = QtPlatformPlugin

# ------ Qt modules ------

defineTest(addOnlyNonQtLibs) {
    # We let the podspec take care of dependencies to other Qt libs
    !contains(2, ^Qt.*): libs += "'$$2'"
    export(libs)
}

defineTest(addAndRecursePrl) {
    libs += "'$$2'"
    prl_file = $$1/lib$${2}.prl
    exists($$prl_file) {
        prl_libs = $$fromfile($$prl_file, QMAKE_PRL_LIBS)
        parseLibs(prl_libs, addOnlyNonQtLibs)
    }
    export(libs)
}

modules = core gui network platformsupport
for(module, modules) {
    unset(INCLUDEPATH)
    unset(LIBS)

    name = $$eval(QT.$${module}.name)
    PODSPEC += "  s.subspec '$$name' do |$$module|"

    qtAddModule($$module, , LIBS)

    unset(libs)
    unset(frameworks)
    parseLibs(LIBS, addAndRecursePrl)

    PODSPEC += "    $${module}.libraries = $$join(libs, ', ')"
    PODSPEC += "    $${module}.frameworks = $$join(frameworks, ', ')"
    PODSPEC += "    $${module}.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/$${name}' }"

    depends = $$eval(QT.$${module}.depends)
    for(dep, depends) {
        depname = $$eval(QT.$${dep}.name)
        PODSPEC += "    $${module}.dependency 'Qt/$$depname'"
    }

    PODSPEC += "  end"
}

PODSPEC += "end"
write_file($$PODSPEC_FILE, PODSPEC)
