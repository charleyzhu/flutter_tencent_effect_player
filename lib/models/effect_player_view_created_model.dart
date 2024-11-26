import '../tencent_effect_player_controller.dart';

/*
 * @Author: Charley
 * @Date: 2024-11-09 17:33:39
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/models/effect_player_view_created_model.dart
 * @LastEditTime: 2024-11-09 17:34:05
 * @LastEditors: Charley
 */
class EffectPlayerViewCreatedModel {
  EffectPlayerViewCreatedModel({required this.viewId, required this.controller});

  /// 视图ID
  final String viewId;

  /// 控制器
  final TencentEffectPlayerController controller;
}
