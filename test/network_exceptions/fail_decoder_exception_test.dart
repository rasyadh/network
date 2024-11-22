import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() async {
  group(FailDecoderException, () {
    test('default value for userMessage', () async {
      final exception = FailDecoderException(
        technicalMessage: "",
      );

      expect(exception.userMessage, NetworkException.failDecoderKey);
    });
  });
}
