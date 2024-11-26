/*
 * @Author: Charley
 * @Date: 2024-11-12 10:54:55
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/models/tencent_effect_image_model.dart
 * @LastEditTime: 2024-11-12 12:05:08
 * @LastEditors: Charley
 */

import '../constant/constant.dart';

enum TCEPImageType {
  // 本地图片
  local,
  // 网络图片
  network,
  // assets图片
  assets,
}

extension TCEPImageTypeExtension on TCEPImageType {
  int get value {
    switch (this) {
      case TCEPImageType.local:
        return 0;
      case TCEPImageType.network:
        return 1;
      case TCEPImageType.assets:
        return 2;
    }
  }
}

class TencentEffectImageModel {
  TencentEffectImageModel({
    required this.imageType,
    required this.tag,
    required this.imageValue,
  });

  final String tag;
  final String imageValue;
  final TCEPImageType imageType;

  // to json
  Map<String, dynamic> toJson() {
    return {
      kMethodArgsKeyImageType: imageType.value,
      kMethodArgsKeyTag: tag,
      kMethodArgsKeyImageValue: imageValue,
    };
  }
}
