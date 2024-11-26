/*
 * @Author: Charley
 * @Date: 2024-11-12 10:47:42
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/models/tencent_effect_text_model.dart
 * @LastEditTime: 2024-11-12 16:28:11
 * @LastEditors: Charley
 */
import '../constant/constant.dart';

class TencentEffectTextModel {
  TencentEffectTextModel({
    required this.tag,
    required this.text,
    this.isBold = false,
    this.alignment = TCEPTextAlignment.none,
    this.textColor,
  });

  // 文字标签
  final String tag;
  // 文字内容
  final String text;
  // 文字样式，是否加粗
  final bool isBold;
  // 文字对齐方式，取值：TCEPTextAlignmentLeft， TCEPTextAlignmentCenter（默认值），TCEPTextAlignmentRight
  final TCEPTextAlignment alignment;
  // 文字颜色，如：“#FF0000”
  final String? textColor;

  // to json
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map[kMethodArgsKeyTag] = tag;
    map[kMethodArgsKeyText] = text;
    map[kMethodArgsKeyAlignment] = alignment.value;
    map[kMethodArgsKeyIsBold] = isBold;
    if (textColor != null) {
      map[kMethodArgsKeyTextColor] = textColor;
    }
    return map;
  }
}

// 文字对齐方式
enum TCEPTextAlignment {
  // 默认值，使用特效文件默认配置的对齐方式
  none,
  // 表示文字左对齐
  left,
  // 表示文字居中对齐
  center,
  // 表示文字右对齐
  right,
}

// 获取对齐方式的值
extension TCEPTextAlignmentExtension on TCEPTextAlignment {
  int get value {
    switch (this) {
      case TCEPTextAlignment.none:
        return -1;
      case TCEPTextAlignment.left:
        return 0;
      case TCEPTextAlignment.center:
        return 1;
      case TCEPTextAlignment.right:
        return 2;
    }
  }
}
