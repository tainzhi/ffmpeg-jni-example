# ffmpeg-jni-example

- 使用jni调用ffmpeg编译生成的动态库`.so`，编入apk

- jni的实现上使用直接传递ffmpeg command的方式，重写了`ffmpeg.c`的`main()`接口，只需要传入合适的ffmpeg命令即可使用





##References##
- [ffmpeg-jni-sample](https://github.com/dxjia/ffmpeg-jni-sample)
