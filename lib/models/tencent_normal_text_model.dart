/*
 * @Author: Charley
 * @Date: 2024-11-12 10:54:55
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/models/tencent_normal_text_model.dart
 * @LastEditTime: 2024-11-12 12:05:34
 * @LastEditors: Charley
 */
import '../constant/constant.dart';

class TencentNormalTextModel {
  TencentNormalTextModel({
    required this.tag,
    required this.text,
  });

  // 文字标签
  final String tag;
  // 文字内容
  final String text;

  // to json
  Map<String, dynamic> toJson() {
    return {
      kTEPMethodArgsKeyTag: tag,
      kTEPMethodArgsKeyText: text,
    };
  }
}
