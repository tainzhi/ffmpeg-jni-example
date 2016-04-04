package com.muqing.android.ffmpeg_jni_example;

import android.util.Log;

/**
 * Created by muqing on 4/4/16.
 */
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
