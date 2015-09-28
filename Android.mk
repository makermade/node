LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := nodejs
LOCAL_MODULE_CLASS := DATA
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_EXECUTABLES)
include $(BUILD_PREBUILT)

$(TARGET_ROOT_OUT)/usr:
	mkdir -p $(TARGET_OUT)/gcc-runtime
	cp -R $(ANDROID_BUILD_TOP)/toolchain/linux-x86/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_runtime/usr $(TARGET_OUT)/gcc-runtime
	ln -sf system/gcc-runtime/usr $@

$(TARGET_ROOT_OUT)/lib:
	mkdir -p $(TARGET_OUT)/gcc-runtime
	cp -R $(ANDROID_BUILD_TOP)/toolchain/linux-x86/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_runtime/lib $(TARGET_OUT)/gcc-runtime
	ln -sf system/gcc-runtime/lib $@

ALL_DEFAULT_INSTALLED_MODULES +=         \
		$(TARGET_ROOT_OUT)/usr   \
		$(TARGET_ROOT_OUT)/lib

$(LOCAL_INSTALLED_MODULE): $(LOCAL_BUILT_MODULE)

.PHONY: $(LOCAL_BUILT_MODULE)
$(LOCAL_BUILT_MODULE):
	(cd node;  \
	export TOOLCHAIN=$(ANDROID_BUILD_TOP)/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.8/bin; \
	export AR=$$TOOLCHAIN/x86_64-linux-ar; \
	export CC=$$TOOLCHAIN/x86_64-linux-gcc; \
	export CXX=$$TOOLCHAIN/x86_64-linux-g++; \
	export LINK=$$TOOLCHAIN/x86_64-linux-g++; \
	./configure --prefix=$(ANDROID_BUILD_TOP)/$(HOST_OUT); \
	$(MAKE) && $(MAKE) install )
	(cd node; \
	export TOOLCHAIN=$(ANDROID_BUILD_TOP)/toolchain/linux-x86/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux/bin; \
	export AR=$$TOOLCHAIN/arm-linux-gnueabihf-ar; \
	export CC=$$TOOLCHAIN/arm-linux-gnueabihf-gcc; \
	export CXX=$$TOOLCHAIN/arm-linux-gnueabihf-g++; \
	export LINK=$$TOOLCHAIN/arm-linux-gnueabihf-g++; \
	./configure \
	  --dest-cpu=arm \
	  --dest-os=linux && \
	$(MAKE) ) && mkdir -p $(@D) && cp node/out/Release/iojs $@
