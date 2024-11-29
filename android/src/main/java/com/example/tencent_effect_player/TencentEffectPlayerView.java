package com.example.tencent_effect_player;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;

import com.tencent.tcmediax.tceffectplayer.api.TCEffectAnimView;
import com.tencent.tcmediax.tceffectplayer.api.TCEffectPlayerConstant;
import com.tencent.tcmediax.tceffectplayer.api.data.TCEffectText;
import com.tencent.tcmediax.tceffectplayer.api.mix.IFetchResource;
import com.tencent.tcmediax.tceffectplayer.api.mix.IFetchResourceImgResult;
import com.tencent.tcmediax.tceffectplayer.api.mix.IFetchResourceTxtResult;
import com.tencent.tcmediax.tceffectplayer.api.mix.Resource;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

/**
 * @author hqg
 * @description:
 * @date : 2024/11/18 15:29
 */
public class TencentEffectPlayerView implements PlatformView, MethodChannel.MethodCallHandler {

    // 原生接口
    ///初始化视图
    final static String _methodInitPlayerView = "method_initPlayerView";
    /// 播放方法
    final static String _methodPlayWithUrl = "method_playWithUrl";
    /// 播放路径
    final static String _methodPlayWithPath = "method_playWithPath";
    /// 播放资源
    final static String _methodPlayWithAsset = "method_playWithAsset";
    /// 暂停播放
    final static String _methodPause = "method_pause";
    /// 继续播放
    final static String _methodResume = "method_resume";
    /// 停止播放
    final static String _methodStop = "method_stop";
    /// 设置静音
    final static String _methodSetMute = "method_setMute";
    /// 设置循环
    final static String _methodSetLoop = "method_setLoop";

    // 参数
    final static String _argumentAutoStart = "autoStart";
    final static String _argumentPlayUrl = "playUrl";
    final static String _argumentPlayPath = "playPath";
    final static String _argumentPlayAsset = "playAsset";
    final static String _argumentIsLoop = "isLoop";
    final static String _argumentMute = "mute";
    final static String _argumentTag = "tag";
    final static String _argumentViewId = "viewId";
    /// tcePlayerError
    final static String _argumentTCEPlayerError = "tcePlayerError";

    // 回调
    ///融合动画资源点击事件回调
    final static String kCallbackMethodTCEffectAnimViewClickEvent = "TCEffectAnimViewClickEventCallback";
    final static String kCallbackMethodTCEffectAnimViewStart = "TCEffectAnimViewStartCallback";
    final static String kCallbackMethodTCEffectAnimViewEnd = "TCEffectAnimViewEndCallback";
    final static String kCallbackMethodTCEffectAnimViewError = "TCEffectAnimViewErrorCallback";
    final static String kCallbackMethodLoadTextForPlayer = "LoadTextForPlayerCallback";
    final static String kCallbackMethodLoadImageForPlayer = "LoadImageForPlayerCallback";

    private TCEffectAnimView mPlayerView;
    private final MethodChannel channel;
    private MethodChannel.Result methodResult;
    private final Context context;

    private boolean autoStart = true;
    private String playUrl;
    private String playPath;
    private String playAsset;
    private boolean isLoop = true;
    private FlutterPlugin.FlutterAssets flutterAssets;
    private String viewId;

    private Map<String, TextModel> textMap = new HashMap<>();
    private Map<String, ImageModel> imageMap = new HashMap<>();

    public TencentEffectPlayerView(FlutterPlugin.FlutterAssets flutterAssets, BinaryMessenger binaryMessenger,
                                   Context context, int id, Map<String, Object> creationParams) {
        this.flutterAssets = flutterAssets;
        mPlayerView = new TCEffectAnimView(context);
        MethodChannel.MethodCallHandler handler = this;
        viewId = id + "";
        if (creationParams.containsKey(_argumentViewId)) {
            viewId = (String) creationParams.get(_argumentViewId);
        }

        String channelViewId = TencentEffectPlayerPlugin._viewChannel + viewId;
        channel = new MethodChannel(binaryMessenger, channelViewId);
        channel.setMethodCallHandler(handler);
        this.context = context;

        if (creationParams != null) {
            if (creationParams.containsKey(_argumentPlayUrl)) {
                playUrl = (String) creationParams.get(_argumentPlayUrl);
            }
            if (creationParams.containsKey(_argumentPlayPath)) {
                playPath = (String) creationParams.get(_argumentPlayPath);
            }
            if (creationParams.containsKey(_argumentPlayAsset)) {
                playAsset = (String) creationParams.get(_argumentPlayAsset);
            }
            if (creationParams.containsKey(_argumentAutoStart)) {
                autoStart = (boolean) creationParams.get(_argumentAutoStart);
            }
            if (creationParams.containsKey(_argumentIsLoop)) {
                isLoop = (boolean) creationParams.get(_argumentIsLoop);
            }
        }

    }


    @Nullable
    @Override
    public View getView() {
        return mPlayerView;
    }

    @Override
    public void dispose() {
        //此方法需要清除所有对象引用，否则会造成内存泄漏
        if (mPlayerView != null) {
            mPlayerView.onDestroy();
            mPlayerView = null;
            Log.d("PlayerView", "dispose回收!!!");
        }
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case _methodInitPlayerView:
                Log.d("onMethodCall", _methodInitPlayerView);
                init();
                break;
            case _methodPlayWithUrl:
                Log.d("onMethodCall", _methodPlayWithUrl);
                playUrl = call.argument(_argumentPlayUrl);
                boolean playerUrlMute = Boolean.TRUE.equals(call.argument(_argumentMute));
                setMute(playerUrlMute);
                mPlayerView.setScaleType(TCEffectPlayerConstant.ScaleType.CENTER_CROP);
                playWithUrl(playUrl);
                break;
            case _methodPlayWithPath:
                Log.d("onMethodCall", _methodPlayWithPath);
                playPath = call.argument(_argumentPlayPath);
                boolean playerPathMute = Boolean.TRUE.equals(call.argument(_argumentMute));
                setMute(playerPathMute);
                mPlayerView.setScaleType(TCEffectPlayerConstant.ScaleType.CENTER_CROP);
                playWithPath(playPath);
                break;
            case _methodPlayWithAsset:
                Log.d("onMethodCall", _methodPlayWithAsset);
                playAsset = call.argument(_argumentPlayAsset);
                boolean playerAssetMute = Boolean.TRUE.equals(call.argument(_argumentMute));
                setMute(playerAssetMute);
                mPlayerView.setScaleType(TCEffectPlayerConstant.ScaleType.CENTER_CROP);
                playWithAsset();
                break;
            case _methodPause:
                Log.d("onMethodCall", _methodPause);
                onPause();
                break;
            case _methodResume:
                Log.d("onMethodCall", _methodResume);
                onResume();
                break;
            case _methodStop:
                Log.d("onMethodCall", _methodStop);
                onStop();
                break;
            case _methodSetMute:
                Log.d("onMethodCall", _methodSetMute);
                boolean mute = Boolean.TRUE.equals(call.argument(_argumentMute));
                setMute(mute);
                break;
            case _methodSetLoop:
                Log.d("onMethodCall", _methodSetLoop);
                boolean loop = Boolean.TRUE.equals(call.argument(_argumentIsLoop));
                setLoop(loop);
                break;
            default:
                Log.d("PlayerView", "notImplemented " + call.method);
                result.notImplemented();
                break;
        }
    }

    //缓存融合动画资源
    private void cacheRes() {
        //缓存资源
        new Handler(Looper.getMainLooper()).post(() -> {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put(_argumentViewId, viewId);
            channel.invokeMethod(kCallbackMethodLoadImageForPlayer, arguments, new MethodChannel.Result() {
                @Override
                public void success(@Nullable Object result) {
                    if (result != null) {
                        List<Map<String, Object>> values = (List<Map<String, Object>>) result;
                        for (Map<String, Object> map : values) {
                            String tag = (String) map.get("tag");
                            int imageType = (int) map.get("imageType");
                            String imageValue = (String) map.get("imageValue");
                            imageMap.put(tag, new ImageModel(imageValue, imageType));
                        }
                    }
                }

                @Override
                public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                }

                @Override
                public void notImplemented() {
                }
            });
        });
        new Handler(Looper.getMainLooper()).post(() -> {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put(_argumentViewId, viewId);
            channel.invokeMethod(kCallbackMethodLoadTextForPlayer, arguments, new MethodChannel.Result() {
                @Override
                public void success(@Nullable Object result) {
                    if (result != null) {
                        List<Map<String, Object>> values = (List<Map<String, Object>>) result;
                        for (Map<String, Object> map : values) {
                            String tag = (String) map.get("tag");
                            String text = (String) map.get("text");
                            String textColor = (String) map.get("textColor");
                            int alignment = (int) map.get("alignment");
                            boolean isBold = (boolean) map.get("isBold");
                            textMap.put(tag, new TextModel(text, textColor, alignment, isBold));
                        }
                    }
                    initPlayView();
                }

                @Override
                public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                }

                @Override
                public void notImplemented() {
                }
            });
        });
    }

    private void init() {
        cacheRes();
    }

    private void initPlayView() {

        if (mPlayerView == null) return;

        mPlayerView.setLoop(isLoop);
        if (autoStart) {
            if (playUrl != null && !playUrl.isEmpty()) {
                playWithUrl(playUrl);
            } else if (playPath != null && !playPath.isEmpty()) {
                playWithPath(playPath);
            } else if (playAsset != null && !playAsset.isEmpty()) {
                playWithAsset();
            }
        }

        //融合动画监听
        mPlayerView.setFetchResource(new IFetchResource() {
            @Override
            public void fetchImage(Resource resource, IFetchResourceImgResult result) {

                ImageModel model = imageMap.get(resource.tag);
                if (model != null) {
                    Bitmap bitmap;

                    if (model.imageType == 2) {
                        //assets图片
                        String assetPath = flutterAssets.getAssetFilePathByName(model.imageValue);
                        bitmap = BitmapUtils.getBitmapFromAssets(context.getAssets(), assetPath);
                    } else if (model.imageType == 0) {
                        //本地图片
                        bitmap = BitmapUtils.getBitmapFromLocalPath(model.imageValue);
                    } else {
                        //网络图片
                        bitmap = BitmapUtils.getBitmapFromUrl(model.imageValue);
                    }
                    result.fetch(bitmap);

                } else {
                    result.fetch(null);
                }

            }

            @Override
            public void fetchText(Resource resource, IFetchResourceTxtResult result) {
                TextModel model = textMap.get(resource.tag);
                if (model != null) {
                    TCEffectText tcEffectText = new TCEffectText();
                    tcEffectText.text = model.text;
                    if (model.textColor != null && !model.textColor.isEmpty()) {
                        tcEffectText.color = Color.parseColor(model.textColor);
                    }
                    if (model.isBold) {
                        tcEffectText.fontStyle = "bold";
                    }
                    //对齐方式
                    tcEffectText.alignment = model.alignment;
                    result.loadTextForPlayer(tcEffectText);
                } else {
                    result.loadTextForPlayer(null);
                }
            }

            @Override
            public void releaseResource(List<Resource> resources) {
                // 资源释放通知
                for (Resource resource : resources) {
                    if (resource.bitmap != null) resource.bitmap.recycle();
                }
            }
        });

        //监听TEP动画自定义资源被点击的事件，需要注册 OnResourceClickListener 监听:监听
        mPlayerView.setOnResourceClickListener(resource -> new Handler(Looper.getMainLooper()).post(() -> {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put(_argumentTag, resource.tag);
            arguments.put(_argumentViewId, viewId);
            channel.invokeMethod(kCallbackMethodTCEffectAnimViewClickEvent, arguments);
        }));

        //播放状态监听
        mPlayerView.setPlayListener(new TCEffectAnimView.IAnimPlayListener() {
            @Override
            public void onPlayStart() {
                Log.d("PlayerView", "onPlayStart");
                new Handler(Looper.getMainLooper()).post(() -> {
                    final HashMap<String, Object> arguments = new HashMap<>();
                    arguments.put(_argumentViewId, viewId);
                    channel.invokeMethod(kCallbackMethodTCEffectAnimViewStart, arguments);
                });
            }

            @Override
            public void onPlayEnd() {
                Log.d("PlayerView", "onPlayEnd");
                new Handler(Looper.getMainLooper()).post(() -> {
                    final HashMap<String, Object> arguments = new HashMap<>();
                    arguments.put(_argumentViewId, viewId);
                    channel.invokeMethod(kCallbackMethodTCEffectAnimViewEnd, arguments);
                });
            }

            @Override
            public void onPlayError(int errorCode) {
                Log.d("PlayerView", "onPlayError" + errorCode);
                new Handler(Looper.getMainLooper()).post(() -> {
                    final HashMap<String, Object> arguments = new HashMap<>();
                    Map<String, Integer> map = new HashMap<>();
                    map.put("code", errorCode);
                    arguments.put(_argumentViewId, viewId);
                    arguments.put(_argumentTCEPlayerError, map);
                    channel.invokeMethod(kCallbackMethodTCEffectAnimViewError, arguments);
                });
            }
        });

//        AnimationCacheManager.getInstance().getAnimationResource("https://p.hiparty.cc/test/image/active/20240910/a388df305eed153c000cba1738a076bb.pag", new AnimationCacheManager.LoadListener() {
//            @Override
//            public void loadComplete(String path) {
//                playWithAsset();
//            }
//        });
    }

    //播放网络资源
    private void playWithUrl(String url) {
        //下载到本地
        AnimationCacheManager.getInstance().getAnimationResource(url, path -> playWithAsset());
    }

    //播放本地资源
    private void playWithPath(String path) {
        if(mPlayerView!=null){
            mPlayerView.startPlay(path);
        }
    }

    //播放Asset文件
    private void playWithAsset() {
        // 获取 assets 文件的相对路径
        String assetPath = flutterAssets.getAssetFilePathByName(playAsset);
        String path = FileUtils.copyAssetToStorage(context, assetPath);
        if(mPlayerView!=null){
            mPlayerView.startPlay(path);
        }
    }

    //暂停播放
    private void onPause() {
        if (mPlayerView != null) {
            mPlayerView.pause();
        }
    }

    //继续播放
    private void onResume() {
        if (mPlayerView != null) {
            mPlayerView.resume();
        }
    }

    //停止播放
    private void onStop() {
        if (mPlayerView != null) {
            mPlayerView.stopPlay(true);
        }
    }

    //设置静音
    private void setMute(boolean mute) {
        if (mPlayerView != null) {
            mPlayerView.setMute(mute);
        }
    }

    //是否循环播放
    private void setLoop(boolean loop) {
        if (mPlayerView != null) {
            mPlayerView.setLoop(loop);
        }
    }


}
