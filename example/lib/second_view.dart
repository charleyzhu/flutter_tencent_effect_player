/*
 * @Author: Charley
 * @Date: 2024-11-15 11:41:23
 * @Description: In User Settings Edit
 * @FilePath: \tencent_effect_player\example\lib\second_view.dart
 * @LastEditTime: 2024-11-22 16:12:47
 * @LastEditors: Hqg
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tencent_effect_player/tencent_effect_player.dart';
import 'package:tencent_effect_player_example/anim_item.dart';

class SecondView extends StatefulWidget {
  const SecondView({super.key});

  @override
  State<SecondView> createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  String _platformVersion = 'Unknown';
  final _tencentEffectPlayerPlugin = TencentEffectPlayerPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _tencentEffectPlayerPlugin.getPlatformVersion() ?? 'Unknown version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Widget _buildAnimationView() {
  //   return SizedBox(
  //     height: 50,
  //     width: 50,
  //     child: TencentEffectPlayerView.asset(
  //       'assets/tcmp4/hiparty_package3_emoji01.tcmp4',
  //       isLoop: true,
  //       onTCEffectAnimViewError: (viewId, error) {
  //         debugPrint('viewId: $viewId error: $error');
  //       },
  //     ),
  //   );
  // }

  // Widget _buildAnimationRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       _buildAnimationView(),
  //       _buildAnimationView(),
  //       _buildAnimationView(),
  //       _buildAnimationView(),
  //       _buildAnimationView(),
  //       _buildAnimationView(),
  //     ],
  //   );
  // }

  // Widget _buildAnimationColumnView() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //       _buildAnimationRow(),
  //     ],
  //   );
  // }

  Widget _buildContent() {
    return ListView.builder(
      itemCount: 50, // 数据长度
      itemBuilder: (context, index) {
        // 房间item布局
        return AnimItem(
          index: index,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('SecondView dispose');
  }
}
