import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() async {
  group(RequestCancelledException, () {
    test('default value for userMessage and technicalMessage', () async {
      final exception = RequestCancelledException();

      expect(exception.userMessage, NetworkException.requestCancelledKey);
      expect(exception.technicalMessage, "The request is manually cancelled");
    });
  });
}
