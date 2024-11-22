import 'package:flutter_test/flutter_test.dart';
import 'package:network_dio/network_dio.dart';
import 'package:faker/faker.dart';
import 'package:network_dio/src/response_adapters.dart';

import 'dummy.dart';

void main() {
  final faker = Faker();

  group('ToDioTransform', () {
    test('toDioResponse', () {
      final network = Dummy.createNetworkResponse(faker);

      final dio = network.toDioResponse();

      expect(network.data, dio.data);
      expect(network.headers, dio.headers.map);
      expect(network.requestOptions.data, dio.requestOptions.data);
      expect(network.statusCode, dio.statusCode);
      expect(network.statusMessage, dio.statusMessage);
      expect(network.extra, dio.extra);
    });

    test('toNetworkResponse', () {
      final dio = Dummy.createDioResponse(faker);

      final network = dio.toNetworkResponse();

      expect(network.data, dio.data);
      expect(network.headers, dio.headers.map);
      expect(network.requestOptions.data, dio.requestOptions.data);
      expect(network.statusCode, dio.statusCode);
      expect(network.statusMessage, dio.statusMessage);
      expect(network.extra, dio.extra);
    });
  });
}
