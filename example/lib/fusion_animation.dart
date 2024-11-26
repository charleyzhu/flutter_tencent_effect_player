/*
 * @Author: Charley
 * @Date: 2024-11-12 17:04:45
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/example/lib/fusion_animation.dart
 * @LastEditTime: 2024-11-12 17:14:06
 * @LastEditors: Charley
 */
import 'package:flutter/material.dart';
import 'package:tencent_effect_player/tencent_effect_player.dart';

class FusionAnimation extends StatelessWidget {
  const FusionAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fusion Animation'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: TencentEffectPlayerView.asset(
          'assets/mp4/fusion_animation.mp4',
          isLoop: true,
          onTextContentForPlayer: (viewId) {
            return [
              TencentNormalTextModel(tag: 'tag1', text: 'QireTechnology'),
            ];
          },
          onLoadTextForPlayer: (viewId) {
            return [
              TencentEffectTextModel(
                tag: 'tag1',
                text: 'QireTechnology',
                textColor: "#3084ff",
                isBold: true,
              ),
            ];
          },
          onLoadImageForPlayer: (viewId) {
            return [
              TencentEffectImageModel(
                tag: 'tag1',
                imageType: TCEPImageType.assets,
                imageValue: 'assets/images/hiparty_package3_emoji01.png',
              ),
            ];
          },
          onTCEffectAnimViewError: (viewId, error) {
            debugPrint('viewId: $viewId error: $error');
          },
        ),
      ),
    );
  }
}
