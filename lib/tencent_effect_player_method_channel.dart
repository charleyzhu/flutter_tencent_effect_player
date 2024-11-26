/*
 * @Author: Charley
 * @Date: 2024-11-08 10:47:25
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/tencent_effect_player_method_channel.dart
 * @LastEditTime: 2024-11-26 15:13:12
 * @LastEditors: Charley
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'constant/constant.dart';
import 'models/index.dart';
import 'tencent_effect_player_platform_interface.dart';

/// An implementation of [TencentEffectPlayerPlatform] that uses method channels.
class MethodChannelTencentEffectPlayer extends TencentEffectPlayerPlatform {
  TencentEffectInitCallback? licenseCheckCallback;

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tencent_effect_player');
  MethodChannelTencentEffectPlayer() {
    // 设置方法调用处理回调
    methodChannel.setMethodCallHandler(methodCallHandlerCallBack);
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(kTEPMethodGetSDKVersion);
    return version;
  }

  // 初始化
  @override
  Future<void> init(
      {required String licenceUrl,
      required String licenceKey,
      bool isLogEnable = false,
      TencentEffectInitCallback? licenseCheckCallback}) async {
    this.licenseCheckCallback = licenseCheckCallback;
    await methodChannel.invokeMethod<dynamic>(kTEPMethodInitSDK, {
      kTEPMethodArgsKeyLicenceUrl: licenceUrl,
      kTEPMethodArgsKeyLicenceKey: licenceKey,
      kTEPMethodArgsKeyIsLogEnable: isLogEnable,
    });
  }

  /// 方法调用处理回调
  Future<dynamic> methodCallHandlerCallBack(MethodCall call) async {
    if (call.method == kTEPCallbackMethodLicenseCheckSuccess) {
      licenseCheckCallback?.call(LicenseCheckCallbackModel(status: LicenseStatus.success));
    } else if (call.method == kTEPCallbackMethodLicenseCheckError) {
      final int? errCode = call.arguments[kTEPMethodArgsKeyErrCode];
      final dynamic param = call.arguments[kTEPMethodArgsKeyParam];
      LicenseCheckCallbackErrorModel error = LicenseCheckCallbackErrorModel(errcode: errCode ?? 0, param: param);
      licenseCheckCallback?.call(LicenseCheckCallbackModel(status: LicenseStatus.fail, error: error));
    }
  }
}
