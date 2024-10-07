package com.example.robotarm_controller

import android.content.Context
import android.net.Uri
import android.view.View
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import org.videolan.libvlc.LibVLC
import org.videolan.libvlc.Media
import org.videolan.libvlc.MediaPlayer
import org.videolan.libvlc.util.VLCVideoLayout

class VlcPlayerView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView, MethodChannel.MethodCallHandler {
    private val videoLayout: VLCVideoLayout
    private val libVLC: LibVLC
    private val mediaPlayer: MediaPlayer

    init {
        videoLayout = VLCVideoLayout(context)

        val args = arrayListOf<String>().apply {
            add("-vvv")
            add("--no-audio")
            add("--vout=android-display")
            add("--clock-jitter=0")
            add("--clock-synchro=0")
            add("--file-caching=150")
            add("--live-caching=150")
            add("--network-caching=200")
            add("--sub-track=0")
            add("--drop-late-frames")
            add("--skip-frames")
            add("--sout-rtp-proto=udp")
        }

        libVLC = LibVLC(context, args)
        mediaPlayer = MediaPlayer(libVLC)

        val url = creationParams?.get("url") as? String ?: "rtp://@:5000"
        val uri = Uri.parse(url)

        mediaPlayer.attachViews(videoLayout, null, false, false)
        val media = Media(libVLC, uri)
        mediaPlayer.media = media
        media.release()
        mediaPlayer.play()
    }

    override fun getView(): View = videoLayout

    override fun dispose() {
        mediaPlayer.stop()
        mediaPlayer.detachViews()
        mediaPlayer.release()
        libVLC.release()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "play" -> {
                mediaPlayer.play()
                result.success(null)
            }
            "pause" -> {
                mediaPlayer.pause()
                result.success(null)
            }
            "stop" -> {
                mediaPlayer.stop()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}

class VlcPlayerViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String?, Any?>
        return VlcPlayerView(context, viewId, creationParams)
    }
}