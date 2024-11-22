import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

import '../dummy.dart';

void main() async {
  final faker = Faker();

  group(NetworkResponseInterceptorHandler, () {
    NetworkResponse? calledResponse;
    NetworkException? calledException;
    final handler = NetworkResponseInterceptorHandler(onNext: (response) {
      calledResponse = response;
    }, onReject: (exception) {
      calledException = exception;
    });

    test('next', () async {
      final response = Dummy.createNetworkResponse(faker);
      calledResponse = null;

      handler.next(response);

      expect(calledResponse, isNot(null));
    });

    test('reject', () async {
      final exception = ResponseException(
        technicalMessage: "",
        userMessage: null,
        response: Dummy.createNetworkResponse(faker),
      );

      calledException = null;

      handler.reject(exception);

      expect(calledException, isNot(null));
    });
  });
}
