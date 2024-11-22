import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() async {
  group(ConnectionRelatedException, () {
    test('default value for userMessage', () async {
      final exception = ConnectionRelatedException(
        technicalMessage: "",
      );

      expect(exception.userMessage, NetworkException.connectionKey);
    });
  });
}
