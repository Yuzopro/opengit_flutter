import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:install_apk_plugin/install_apk_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('install_apk_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await InstallApkPlugin.platformVersion, '42');
  });
}
