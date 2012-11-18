Pod::Spec.new do |s|
  s.name         = "Qt"
  s.version      = "5.0.0"
  s.summary      = "Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language."
  s.homepage     = "http://qt-project.org/"
  s.author       = "The Qt Project"
  s.license      = "LGPL"

  s.source       = { :git => "https://github.com/torarnv/qtiostoolbox.git" }
  s.platform     = :ios
  s.source_files = 'QtQuickView'

  # FIXME: Generate based on prl files
  s.frameworks = 'CoreFoundation', 'OpenGLES'
  s.libraries = 'z', 'm'
end