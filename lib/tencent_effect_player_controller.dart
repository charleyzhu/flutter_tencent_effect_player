/*
 * @Author: Charley
 * @Date: 2024-11-09 16:25:09
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/tencent_effect_player_controller.dart
 * @LastEditTime: 2024-11-26 09:54:39
 * @LastEditors: Charley
 */

import 'package:flutter/services.dart';
import 'constant/constant.dart';

class TencentEffectPlayerController {
  TencentEffectPlayerController({required String viewId}) : _channel = MethodChannel(viewId);

  final MethodChannel _channel;

  /// 播放视频
  Future<void> playWithUrl({required String url}) async {
    await _channel.invokeMethod(kCallbackMethodPlayWithUrl, {"url": url});
  }

  /// 播放路径
  Future<void> playWithPath({required String path}) async {
    await _channel.invokeMethod(kCallbackMethodPlayWithPath, {"path": path});
  }

  /// 播放资源
  Future<void> playWithAsset({required String asset}) async {
    await _channel.invokeMethod(kCallbackMethodPlayWithAsset, {"asset": asset});
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
