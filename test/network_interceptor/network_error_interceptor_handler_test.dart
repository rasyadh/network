import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

import '../dummy.dart';

void main() async {
  final faker = Faker();

  group(NetworkErrorInterceptorHandler, () {
    NetworkException? calledException;
    final handler = NetworkErrorInterceptorHandler(onReject: (exception) {
      calledException = exception;
    });

    final exception = ResponseException(
      technicalMessage: "",
      userMessage: null,
      response: Dummy.createNetworkResponse(faker),
    );

    test('next', () async {
      calledException = null;

      handler.next(exception);

      expect(calledException, isNot(null));
    });

    test('reject', () async {
      calledException = null;

      handler.reject(exception);

      expect(calledException, isNot(null));
    });
  });
}
