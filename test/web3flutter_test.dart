import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3flutter/web3flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('web3flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Web3flutter.platformVersion, '42');
  });
}
