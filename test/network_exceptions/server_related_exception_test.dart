import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

import '../dummy.dart';

void main() async {
  final faker = Faker();

  group(ServerRelatedException, () {
    test('default value for userMessage', () async {
      final exception = ServerRelatedException(
        technicalMessage: "",
        response: Dummy.createNetworkResponse(faker),
      );

      expect(exception.userMessage, NetworkException.serverKey);
    });
  });
}
