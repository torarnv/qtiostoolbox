Pod::Spec.new do |s|
  s.name       = 'Qt'
  s.version    = '5.0.0'
  s.summary    = 'Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language.'
  s.homepage   = 'http://qt-project.org/'
  s.author     = 'The Qt Project'
  s.license    = 'LGPL'
  s.source         = { :git => 'https://github.com/torarnv/qtiostoolbox.git' }
  s.platform       = :ios
  s.source_files   = 'QtQuickView'
  s.subspec 'QtPlatformPlugin' do |platformplugin|
    platformplugin.xcconfig = { 'OTHER_LDFLAGS' => '-force_load $(SDKROOT)/usr/plugins/platforms/libqios.a' }
    platformplugin.libraries = 'z', 'm'
    platformplugin.frameworks = 'UIKit', 'QuartzCore', 'CoreFoundation', 'OpenGLES'
    platformplugin.dependency 'Qt/QtPlatformSupport'
    platformplugin.dependency 'Qt/QtGui'
    platformplugin.dependency 'Qt/QtCore'
  end
  s.subspec 'QtCore' do |core|
    core.libraries = 'Qt5Core', 'z', 'm'
    core.frameworks = 'CoreFoundation'
    core.xcconfig = {
      'ADDITIONAL_SDKS'     => '${PODS_ROOT}/Qt/SDK/$(PLATFORM_NAME).sdk',
      'VALID_ARCHS'         => 'armv7',
      'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/QtCore'
    }
  end
  s.subspec 'QtGui' do |gui|
    gui.libraries = 'Qt5Gui', 'z', 'm', 'z'
    gui.frameworks = 'CoreFoundation', 'OpenGLES'
    gui.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/QtGui' }
    gui.dependency 'Qt/QtCore'
    gui.dependency 'Qt/QtPlatformPlugin'
  end
  s.subspec 'QtNetwork' do |network|
    network.libraries = 'Qt5Network', 'z', 'm', 'z'
    network.frameworks = 'CoreFoundation', 'Security', 'SystemConfiguration', 'CoreFoundation'
    network.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/QtNetwork' }
    network.dependency 'Qt/QtCore'
  end
  s.subspec 'QtPlatformSupport' do |platformsupport|
    platformsupport.libraries = 'Qt5PlatformSupport', 'z', 'm'
    platformsupport.frameworks = 'CoreFoundation', 'OpenGLES', 'OpenGLES'
    platformsupport.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/QtPlatformSupport' }
    platformsupport.dependency 'Qt/QtCore'
    platformsupport.dependency 'Qt/QtGui'
  end
end
