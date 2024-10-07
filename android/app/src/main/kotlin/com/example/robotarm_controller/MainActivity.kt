package com.example.robotarm_controller

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.robotarm_controller/vlc_player"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("com.example.robotarm_controller/vlc_player_view", VlcPlayerViewFactory())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializePlayer" -> {
                    // 필요한 경우 여기서 플레이어 초기화
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}