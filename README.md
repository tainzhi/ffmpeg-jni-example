
# ffmpeg-jni-example

- 使用jni调用ffmpeg编译生成的动态库`.so`，编入apk

- jni的实现上使用直接传递ffmpeg command的方式，重写了`ffmpeg.c`的`main()`接口，只需要传入合适的ffmpeg命令即可使用


## 支持平台
获取手机cpu平台
```
adb shell cat /proc/cpuinfo
```
我的手机是**aarch64**,即**arm64-v8a**，所以动态库应该放置在`$Project/app/src/main/jniLibs/arm64-v8a`,但是我尝试没有成功</br>


好在是兼容32位的，所以可以编译支持**arm**的库，动态库放置在`$Project/app/src/main/jniLibs/armeabi`，为了兼容32位，**就不能有arm64-v8a目录的存在**

## how to use
### Step 1
编写`FFmpegNativeHelper.java`
```
package com.muqing.android.ffmpeg_jni_example;

public class FFmpegNativeHelper {
    public FFmpegNativeHelper() {

    }

    static {
        System.loadLibrary("...");
    }

    public int ffmpegCommand(String comand) {
        if (comand.isEmpty()) {
            return 1;
        }
        String  args[] = comand.split(" ");
        for (int i = 0; i < args.length; i++) {
            Log.d("ffmpeg-jni", args[i]);
        }
        return ffmpeg_entry(args.length, args);
    }

    public native int ffmpeg_entry(int argc, String[] args);
}
```

### Step 2
**生成jni cpp header**

```
cd $Project/app/src/main/java
javah -jni com.muqing.android.ffmpeg_jni_example.FFmpegNativeHelper
```
在该目录下生成`com_muqing_android_ffmpeg_jni_example_FFmpegNativeHelper.h`,声明了`ffmpeg_entry`
拷贝到`$Project/app/src/main/java/jni`目录下

新建`com_muqing_android_ffmpeg_example_FFmegNativeHelper.c`,如下
```
#include "com_muqing_android_ffmpeg_jni_example_FFmpegNativeHelper.h"

# this method change the main() in ffmpeg.c
JNIEXPORT jint JNICALL Java_com_muqing_android_ffmpeg_1jni_1example_FFmpegNativeHelper_ffmpeg_1entry
        (JNIEnv * env, jobject thiz, jint argCount, jobjectArray strArray)
{
}

```

### Step 3
**拷贝prebuilt shared libray**</br>
从我的另一个项目[ffmpeg-for-android-shared-library](https://github.com/tainzhi/ffmpeg-for-android-shared-library)中生成的`include`和`lib`分别拷贝到`$PROJECT/app/src/main/jni/include`和`$PROJECT/app/src/main/jni/prebuilt`目录下

因为`com_muqing_android_ffmpeg_example_jni_example_FFmpegNativeHelper.c`只修改了`ffmpeg.c`, 所以为了编译通过，需要添加以下文件
```
include/compat/va_copy.h
libavcodec/arm/mathops.h OR libavutil/x86/mathops.h
libavcodec/mathops.h
libavresample/avresample.h
libavresample/version.h
libavutil/x86/asm.h
libavutil/libm.h
libpostproc/postprocess.h
libpostproc/version.h
```
这些文件可以从ffmpeg源码中拷贝之后加以修改

### Step 4
**编写Android.mk**
因为是fork了别人的项目，原始项目支持arm,x86平台，所以它的mk文件是这样的
```
ifeq ($(APP_ABI), x86)
include Android.x86.mk
else ifeq ($(APP_ABI), arm64-v8a)
include Android.arm64-v8a.mk
else
include Android.arm.mk
endif
```
根据`Application.mk`来判断
```
# APP_ABI := arm64-v8a
APP_ABI := armeabi
```

下面，我们看看`Android.arm.mk`
- 首先，`LOCAL_PATH := $(call my-dir)`
- 接着，报杭shared library的module nam和位置，如下
```
include $(CLEAR_VARS)
LOCAL_MODULE:= avcodec-prebuilt-armeabi
LOCAL_SRC_FILES:= prebuilt/libavcodec.so
include $(PREBUILT_SHARED_LIBRARY)
```
- 然后，指定将要生成的module name，此处是
```
LOCAL_MODULE := libffmpegjni
```
- 紧接着，包含了需要编译的src文件,不需要包含头文件
```
LOCAL_SRC_FILES := com_muqing_android_ffmpeg_jni_example_FFmpegNativeHelper.c \
                   cmdutils.c \
                   ffmpeg_opt.c \
                   ffmpeg_filter.c
```
- 在接着，`LOCAL_SHARED_LIBRARIES`

- 最后，包含include头文件
```
LOCAL_C_INCLUDES += $(LOCAL_PATH)/include
```

### Step 5
```
ndk-build 
ndk-build clean     # if needed, clean the cache, then rebuild
```

### Step 6

在`$Project/app/src/main/java/jni`下生成`libs.armeabi`和`obj.local.armeabi`

拷贝`libs.armeabi`目录下文件到`$Project/app/src/main/jniLibs/armeabi`

### Step 7
现在需要补全之前`FFmpegNativeHelper.java`中的lib库
```
public class FFmpegNativeHelper {
    public FFmpegNativeHelper() {

    }

    static {
        System.loadLibrary("avcodec");
        System.loadLibrary("avdevice");
        System.loadLibrary("avfilter");
        System.loadLibrary("avformat");
        System.loadLibrary("avutil");
        System.loadLibrary("ffmpegjni");
        System.loadLibrary("swresample");
        System.loadLibrary("swscale");
    }

    public int ffmpegCommand(String comand) {
        if (comand.isEmpty()) {
            return 1;
        }
        String  args[] = comand.split(" ");
        for (int i = 0; i < args.length; i++) {
            Log.d("ffmpeg-jni", args[i]);
        }
        return ffmpeg_entry(args.length, args);
    }

    public native int ffmpeg_entry(int argc, String[] args);
}

```

### Step 8
在`MainActivity.java`中
```
    Sring ffmpegCommand = "ffmpeg --version";>
    new FFmpegNativeHelper().ffmpegCommand(ffmpegCommand);
```



## Todo
使用gradle把Android.mk集成到Android Studio

- 在`$PROJECT/app/src/main/jni/`下添加c/c++文件即可
- 配置NDK

## References
- [ffmpeg-jni-sample](https://github.com/dxjia/ffmpeg-jni-sample)
