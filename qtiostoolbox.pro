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
    parse_prl = $$2

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
            equals(parse_prl, true) {
                libs += "'$$lib'"
                prl_file = $$path/lib$${lib}.prl
                exists($$prl_file): prl_libs = $$fromfile($$path/lib$${lib}.prl, QMAKE_PRL_LIBS)
                parseLibs(prl_libs, false)
            } else:!contains(lib, ^Qt.*) {
                # We let the specfile take care of dependencies, so we only add non-Qt libraries
                libs += "'$$lib'"
            }
        } else:equals(framework, true) {
            frameworks += "'$$lib'"
        }

        unset(framework)
    }

    export(libs)
    export(frameworks)
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
    parseLibs(LIBS, true)

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
