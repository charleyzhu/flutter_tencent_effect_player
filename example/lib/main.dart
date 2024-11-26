/*
 * @Author: Charley
 * @Date: 2024-11-08 10:47:25
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/example/lib/main.dart
 * @LastEditTime: 2024-11-26 09:59:29
 * @LastEditors: Charley
 */
import 'package:flutter/material.dart';
import 'package:tencent_effect_player/tencent_effect_player.dart';
import 'package:tencent_effect_player_example/home.dart';

import 'second_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _tencentEffectPlayerPlugin = TencentEffectPlayerPlugin();

  @override
  void initState() {
    _tencentEffectPlayerPlugin.init(
        licenceUrl: '',
        licenceKey: '',
        licenseCheckCallback: (model) {
          debugPrint('license check: ${model.status}');
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: {
        '/': (context) => const Home(), // 主页面
        // '/fusion': (context) => const FusionAnimation(), // 动画页面
        '/second': (context) => const SecondView(), // 动画页面
      },
      initialRoute: "/",
    );
  }
}
