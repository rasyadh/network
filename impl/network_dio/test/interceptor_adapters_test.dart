import 'package:flutter_test/flutter_test.dart';
import 'package:network_dio/network_dio.dart';

void main() {
  group(NetworkInterceptor, () {
    test('toDioInterceptor', () {
      final network = NetworkInterceptor();

      expect(network.toDioInterceptor(), isA<Interceptor>());
    });
  });
}
