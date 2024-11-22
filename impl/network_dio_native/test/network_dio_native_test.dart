import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_dio_native/network_dio_native.dart';

void main() {
  test('NetworkNativeClientDio', () {
    // can only work on pipelines where it'll use the dart io fallback.
    // the internal platform specific adapter only work in some platform
    if (!Platform.isAndroid && !Platform.isIOS && !Platform.isMacOS) {
      final client = NetworkNativeClientDio();
      expect(client.dioClient.httpClientAdapter, isA<NativeAdapter>());
    }
  });
}
