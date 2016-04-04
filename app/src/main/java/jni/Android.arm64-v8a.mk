LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE:= avcodec-prebuilt-arm64-v8a
LOCAL_SRC_FILES:= prebuilt/arm64-v8a/libavcodec.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE:= avdevice-prebuilt-arm64-v8a
LOCAL_SRC_FILES:= prebuilt/arm64-v8a/libavdevice.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE:= avfilter-prebuilt-arm64-v8a
LOCAL_SRC_FILES:= prebuilt/arm64-v8a/libavfilter.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE:= avformat-prebuilt-arm64-v8a
LOCAL_SRC_FILES:= prebuilt/arm64-v8a/libavformat.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE :=  avutil-prebuilt-arm64-v8a
LOCAL_SRC_FILES := prebuilt/arm64-v8a/libavutil.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := swresample-prebuilt-arm64-v8a
LOCAL_SRC_FILES := prebuilt/arm64-v8a/libswresample.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := swscale-prebuilt-arm64-v8a
LOCAL_SRC_FILES := prebuilt/arm64-v8a/libswscale.so
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libffmpegjni


LOCAL_SRC_FILES := FFmpegNativeHelper.c \
                   cmdutils.c \
                   ffmpeg_opt.c \
                   ffmpeg_filter.c

LOCAL_LDLIBS := -L$(SYSROOT)/usr/lib -llog -lz

LOCAL_SHARED_LIBRARIES:= avcodec-prebuilt-arm64-v8a \
                         avdevice-prebuilt-arm64-v8a \
                         avfilter-prebuilt-arm64-v8a \
                         avformat-prebuilt-arm64-v8a \
                         avutil-prebuilt-arm64-v8a \
                         swresample-prebuilt-arm64-v8a \
                         swscale-prebuilt-arm64-v8a

LOCAL_C_INCLUDES += -L$(SYSROOT)/usr/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/include

LOCAL_CFLAGS := -DUSE_ARM_CONFIG

include $(BUILD_SHARED_LIBRARY)



