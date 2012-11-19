TEMPLATE = subdirs

podspec.commands = $(QMAKE) podspec.pri -o /dev/null OUT_PWD=$$OUT_PWD
QMAKE_EXTRA_TARGETS += podspec