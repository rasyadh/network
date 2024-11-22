import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() async {
  group(BadDataException, () {
    test('default value for userMessage', () async {
      final exception = BadDataException(
        technicalMessage: "",
      );

      expect(exception.userMessage, NetworkException.badDataKey);
    });
  });
}
