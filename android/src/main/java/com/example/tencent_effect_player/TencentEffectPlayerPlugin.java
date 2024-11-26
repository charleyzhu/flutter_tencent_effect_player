package com.example.tencent_effect_player;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.tencent.tcmediax.api.ILicenseCallback;
import com.tencent.tcmediax.api.TCMediaXBase;
import com.tencent.tcmediax.api.TXLicenceErrorCode;

import java.util.HashMap;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TencentEffectPlayerPlugin
 */
public class TencentEffectPlayerPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;

    // 使用时替换 LICENCE_URL 为自己的 LICENCE_URL
    private String licenceUrl = "";
    private String licenceKey = "";
    /**
     * License 可以使用的备用域名， 在被 License 域名被劫持或域名不能访问后，用下面的域名替换后进行重试
     * 域名 1： plugin.vodglcdn.com
     * 域名 2： plugin.vod-common.com
     * 重试时使用不同域名的 License Url
     * 使用时请把 $your_license_url_suffix 替换为您的 LicenseUrl 后缀，
     * 例如：如果您的 License Url 为 https://trtc-plugin.qcloud.com/plugin/v1/1301671788/license.json，
     * 则把 $your_license_url_suffix 替换为 plugin/v1/1301671788/license.json
     */
    private static final String[] sBackUpLicenseUrl = {
            "https://plugin.vodglcdn.com/$your_license_url_suffix",
            "https://plugin.vod-common.com/$your_license_url_suffix"};


    private int mRetryCount = 0;  // 当前重试次数


    // view
    final static String _viewKey = "tencent_effect_player_view";
    final static String _viewChannel = "tencent_effect_player_view_channel_";

    // 原生接口
    final static String _nativeGetSDKVersion = "getSDKVersion";
    final static String _nativeInitSDK = "initSDK";

    // 参数
    final static String _argumentLicenceUrl = "licenceUrl";
    final static String _argumentLicenceKey = "licenceKey";
    final static String _argumentIsLogEnable = "isLogEnable";
    final static String _argumentErrCode = "errCode";
    final static String _argumentParam = "param";

    // 回调
    final static String _licenseCheckSuccessCallback = "LicenseCheckSuccessCallback";
    final static String _licenseCheckErrorCallback = "LicenseCheckErrorCallback";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tencent_effect_player");
        channel.setMethodCallHandler(this);

        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(
                _viewKey,
                new TencentEffectPlayerFactory(
                        flutterPluginBinding.getBinaryMessenger(),
                        flutterPluginBinding.getFlutterAssets()
                )
        );
        AnimationCacheManager.getInstance().initDiskCache(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        switch (call.method) {
            case _nativeGetSDKVersion:
                result.success("Android V" + TCMediaXBase.getInstance().getSdkVersion());
                break;
            case _nativeInitSDK:
                initSDK(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    private final ILicenseCallback mLicenseCallback = new ILicenseCallback() {
        @Override
        public void onResult(int errCode, String msg) {
            Log.d("TCMediaXBase", "onResult code-->" + errCode + "--msg-->" + msg);
            if (errCode == TXLicenceErrorCode.LicenseCheckOk) {
                new Handler(Looper.getMainLooper()).post(() -> {
                    channel.invokeMethod(_licenseCheckSuccessCallback, null);
                });
            } else if (errCode == TXLicenceErrorCode.LicenseCheckDownloadError) {
                if (mRetryCount < sBackUpLicenseUrl.length) {
                    //  License校验，用替换域名后的 License Url 进行重试
                    //  此时业务可以把 LicenseUrl、 错误码、网络状态进行上报，然后反馈给腾讯云播放器客服
                    String licenseUrl = sBackUpLicenseUrl[mRetryCount % sBackUpLicenseUrl.length];
                    TCMediaXBase.getInstance().setLicense(context, licenseUrl, licenceKey, mLicenseCallback);
                    mRetryCount++;
                } else {
                    // 超过重试次数，可能是网络不可用， 可以发消息给 app 进行相关提示，找另外时机重新调用 TCMediaXBase#setLicense
                    mRetryCount = 0;
                }
            } else {
                new Handler(Looper.getMainLooper()).post(() -> {
                    final HashMap<String, Object> arguments = new HashMap<>();
                    arguments.put(_argumentErrCode, errCode);
                    arguments.put(_argumentParam, msg);
                    channel.invokeMethod(_licenseCheckErrorCallback, arguments);
                });
            }
        }
    };

    //SDK初始化
    private void initSDK(final MethodCall call, final Result result) {
        licenceUrl = call.argument(_argumentLicenceUrl);
        licenceKey = call.argument(_argumentLicenceKey);
        boolean isLogEnable = Boolean.TRUE.equals(call.argument(_argumentIsLogEnable));

        TCMediaXBase.getInstance().setLicense(context, licenceUrl, licenceKey, mLicenseCallback);
        TCMediaXBase.getInstance().setLogEnable(context, isLogEnable);
    }

}
