# ffmpeg-jni-example

- 使用jni调用ffmpeg编译生成的动态库`.so`，编入apk

- jni的实现上使用直接传递ffmpeg command的方式，重写了`ffmpeg.c`的`main()`接口，只需要传入合适的ffmpeg命令即可使用


生成jni cpp header

```
cd $Project/app/src/main/java
javah -jni com.muqing.android.ffmpeg_jni_example.FFmpegNativeHelper
```
在该目录下生成`com_muqing_android_ffmpeg_jni_example_FFmpegNativeHelper.h`
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


拷贝prebuilt shared libray
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


ndk-build 
ndk-build clean     # rebuild


在`$Project/app/src/main/java/jni`下生成`libs.armeabi`和`obj.local.armeabi`

拷贝`libs.armeabi`目录下文件到`$Project/app/src/main/jniLibs/armeabi`




##Todo
使用gradle把Android.mk集成到Android Studio

- 在`$PROJECT/app/src/main/jni/`下添加c/c++文件即可
- 配置NDK

##References##
- [ffmpeg-jni-sample](https://github.com/dxjia/ffmpeg-jni-sample)
