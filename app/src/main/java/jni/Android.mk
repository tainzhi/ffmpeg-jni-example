ifeq ($(APP_ABI), x86)
include Android.x86.mk
else ifeq ($(APP_ABI), arm64-v8a)
include Android.arm64-v8a.mk
else
include Android.arm.mk
endif

