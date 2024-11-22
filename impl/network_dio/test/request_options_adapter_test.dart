import 'package:flutter_test/flutter_test.dart';
import 'package:network_dio/network_dio.dart';
import 'package:faker/faker.dart';

import 'dummy.dart';

void main() {
  final faker = Faker();

  group('ToDioTransform', () {
    test('toDioOptions', () {
      final network = Dummy.createNetworkRequestOptions(faker);

      final dio = network.toDioOptions();

      expect(network.method, dio.method);
      expect(network.headers, dio.headers);
      expect(network.timeout, dio.connectTimeout?.inMilliseconds);
      expect(network.timeout, dio.receiveTimeout?.inMilliseconds);
      expect(network.timeout, dio.sendTimeout?.inMilliseconds);
      expect(network.data, dio.data);
      expect(network.queryParameters, dio.queryParameters);
      expect(network.extra, dio.extra);
      expect(network.responseType.toDioResponseType(), dio.responseType);
    });
  });

  group('FromDioTransform', () {
    test('toNetworkRequestOptions', () {
      final dio = Dummy.createDioRequestOptions(faker);

      final network = dio.toNetworkRequestOptions();

      expect(network.method, dio.method);
      expect(network.headers, dio.headers);
      expect(network.timeout, dio.connectTimeout?.inMilliseconds);
      expect(network.data, dio.data);
      expect(network.queryParameters, dio.queryParameters);
      expect(network.extra, dio.extra);
      expect(network.responseType, dio.responseType.toNetworkResponseType());
    });
  });
}
