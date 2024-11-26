import 'package:flutter/material.dart';
import 'package:tencent_effect_player/tencent_effect_player_view.dart';

class AnimItem extends StatelessWidget {
  final int index;

  const AnimItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          Text(
            "动画$index",
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: TencentEffectPlayerView.asset(
              'assets/tcmp4/hiparty_package3_emoji01.tcmp4',
              isLoop: true,
              onTCEffectAnimViewError: (viewId, error) {
                debugPrint('viewId: $viewId error: $error');
              },
            ),
          ),
        ],
      ),
    );
  }
}
