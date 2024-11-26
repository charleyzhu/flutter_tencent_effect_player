/*
 * @Author: Charley
 * @Date: 2024-11-09 16:25:09
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/tencent_effect_player_controller.dart
 * @LastEditTime: 2024-11-26 14:25:51
 * @LastEditors: Charley
 */

import 'package:flutter/services.dart';
import 'constant/constant.dart';

class TencentEffectPlayerController {
  TencentEffectPlayerController({required String viewId}) : _channel = MethodChannel(viewId);

  final MethodChannel _channel;

  /// 播放视频
  Future<Map<dynamic, dynamic>?> playWithUrl({required String url, bool isMute = false}) async {
    return _channel.invokeMethod(kCallbackMethodPlayWithUrl, {kMethodArgsKeyPlayUrl: url, "isMute": isMute});
  }

  /// 播放路径
  Future<Map<dynamic, dynamic>?> playWithPath({required String path, bool isMute = false}) async {
    return _channel.invokeMethod(kCallbackMethodPlayWithPath, {kMethodArgsKeyPlayPath: path, "isMute": isMute});
  }

  /// 播放资源
  Future<Map<dynamic, dynamic>?> playWithAsset({required String asset, bool isMute = false}) async {
    return _channel.invokeMethod(kCallbackMethodPlayWithAsset, {kMethodArgsKeyPlayAsset: asset, "isMute": isMute});
  }

  ///   暂停播放
  Future<void> pause() async {
    await _channel.invokeMethod(kCallbackMethodPause);
  }

  /// 继续播放
  Future<void> resume() async {
    await _channel.invokeMethod(kCallbackMethodResume);
  }

  /// 停止播放
  Future<void> stop() async {
    await _channel.invokeMethod(kCallbackMethodStop);
  }

  /// 设置静音
  Future<void> setMute({required bool mute}) async {
    await _channel.invokeMethod(kCallbackMethodSetMute, {kMethodArgsKeyMute: mute});
  }

  /// 设置循环
  Future<void> setLoop({required bool loop}) async {
    await _channel.invokeMethod(kCallbackMethodSetLoop, {kMethodArgsKeyLoop: loop});
  }
}
