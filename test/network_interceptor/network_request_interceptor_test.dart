import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

import '../dummy.dart';

void main() async {
  final faker = Faker();

  group(NetworkRequestInterceptorHandler, () {
    NetworkRequestOptions? calledResponse;
    NetworkException? calledException;
    final handler = NetworkRequestInterceptorHandler(onNext: (response) {
      calledResponse = response;
    }, onReject: (exception) {
      calledException = exception;
    });

    test('next', () async {
      calledResponse = null;

      handler.next(NetworkRequestOptions());

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
