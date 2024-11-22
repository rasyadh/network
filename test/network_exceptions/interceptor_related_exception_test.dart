import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() async {
  group(InterceptorRelatedException, () {
    test('default value for userMessage', () async {
      final exception = InterceptorRelatedException(
        technicalMessage: "",
      );

      expect(exception.userMessage, NetworkException.connectionKey);
    });
  });
}
