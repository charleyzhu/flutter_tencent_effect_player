import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'constant/callback.dart';
import 'tencent_effect_player_method_channel.dart';

abstract class TencentEffectPlayerPlatform extends PlatformInterface {
  /// Constructs a TencentEffectPlayerPlatform.
  TencentEffectPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static TencentEffectPlayerPlatform _instance = MethodChannelTencentEffectPlayer();

  /// The default instance of [TencentEffectPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelTencentEffectPlayer].
  static TencentEffectPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TencentEffectPlayerPlatform] when
  /// they register themselves.
  static set instance(TencentEffectPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init({required String licenceUrl, required String licenceKey, bool isLogEnable = true, TencentEffectInitCallback? licenseCheckCallback}) {
    throw UnimplementedError('init() has not been implemented.');
  }
}
