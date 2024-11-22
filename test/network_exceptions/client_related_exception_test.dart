import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

import '../dummy.dart';

void main() async {
  final faker = Faker();

  group(ClientRelatedException, () {
    test('userMessage is null', () async {
      final exception = ClientRelatedException(
        technicalMessage: "",
        userMessage: null,
        response: Dummy.createNetworkResponse(faker),
      );

      expect(exception.userMessage, NetworkException.clientKey);
    });
    test('userMessage is not null', () async {
      final givenMessage = faker.lorem.sentence();
      final exception = ClientRelatedException(
        technicalMessage: '',
        userMessage: givenMessage,
        response: Dummy.createNetworkResponse(faker),
      );

      expect(exception.userMessage, givenMessage);
    });
  });
}
