include $(THEOS)/makefiles/common.mk

SDKVERSION = 9.3
SYSROOT = $(THEOS)/sdks/iPhoneOS9.3.sdk

TWEAK_NAME = WriteAnywhere
WriteAnywhere_FILES = Tweak.xm
WriteAnywhere_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
