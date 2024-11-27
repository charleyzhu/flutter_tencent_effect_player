/*
 * @Author: Charley
 * @Date: 2024-11-08 10:47:25
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/test/tencent_effect_player_test.dart
 * @LastEditTime: 2024-11-27 14:25:48
 * @LastEditors: Charley
 */
import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_effect_player/constant/constant.dart';
import 'package:tencent_effect_player/tencent_effect_player.dart';
import 'package:tencent_effect_player/tencent_effect_player_platform_interface.dart';
import 'package:tencent_effect_player/tencent_effect_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTencentEffectPlayerPlatform with MockPlatformInterfaceMixin implements TencentEffectPlayerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> init(
          {required String licenceKey,
          required String licenceUrl,
          bool isLogEnable = false,
          TencentEffectInitCallback? licenseCheckCallback}) =>
      Future.value();
}

void main() {
  final TencentEffectPlayerPlatform initialPlatform = TencentEffectPlayerPlatform.instance;

  test('$MethodChannelTencentEffectPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTencentEffectPlayer>());
  });

  test('getPlatformVersion', () async {
    TencentEffectPlayerPlugin tencentEffectPlayerPlugin = TencentEffectPlayerPlugin();
    MockTencentEffectPlayerPlatform fakePlatform = MockTencentEffectPlayerPlatform();
    TencentEffectPlayerPlatform.instance = fakePlatform;

    expect(await tencentEffectPlayerPlugin.getPlatformVersion(), '42');
  });
}
