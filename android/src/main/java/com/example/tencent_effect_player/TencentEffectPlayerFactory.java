package com.example.tencent_effect_player;

import android.content.Context;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * @author hqg
 * @description:
 * @date : 2024/11/18 15:50
 */

public class TencentEffectPlayerFactory extends PlatformViewFactory {

    private BinaryMessenger binaryMessenger;
    private FlutterPlugin.FlutterAssets flutterAssets;

    public TencentEffectPlayerFactory(BinaryMessenger binaryMessenger, FlutterPlugin.FlutterAssets flutterAssets) {
        super(StandardMessageCodec.INSTANCE);
        this.binaryMessenger = binaryMessenger;
        this.flutterAssets = flutterAssets;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> creationParams = (Map<String, Object>) args;
        return new TencentEffectPlayerView(flutterAssets, binaryMessenger, context, viewId, creationParams);
    }
}