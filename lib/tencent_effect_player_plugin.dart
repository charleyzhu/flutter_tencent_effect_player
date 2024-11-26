/*
 * @Author: Charley
 * @Date: 2024-11-09 15:39:47
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/tencent_effect_player_plugin.dart
 * @LastEditTime: 2024-11-15 15:42:22
 * @LastEditors: Charley
 */
import 'constant/callback.dart';
import 'tencent_effect_player_platform_interface.dart';

class TencentEffectPlayerPlugin {
  Future<String?> getPlatformVersion() {
    return TencentEffectPlayerPlatform.instance.getPlatformVersion();
  }

  Future<void> init(
      {required String licenceUrl,
      required String licenceKey,
      bool isLogEnable = true,
      TencentEffectInitCallback? licenseCheckCallback}) {
    return TencentEffectPlayerPlatform.instance.init(
        licenceUrl: licenceUrl,
        licenceKey: licenceKey,
        isLogEnable: isLogEnable,
        licenseCheckCallback: licenseCheckCallback);
  }
}
