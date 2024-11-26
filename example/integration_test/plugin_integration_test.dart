/*
 * @Author: Charley
 * @Date: 2024-11-08 10:47:25
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/example/integration_test/plugin_integration_test.dart
 * @LastEditTime: 2024-11-09 15:42:04
 * @LastEditors: Charley
 */
// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tencent_effect_player/tencent_effect_player.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final TencentEffectPlayerPlugin plugin = TencentEffectPlayerPlugin();
    final String? version = await plugin.getPlatformVersion();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version?.isNotEmpty, true);
  });
}
