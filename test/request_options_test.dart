import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() async {
  group(NetworkRequestOptions, () {
    test('GET', () async {
      final options = NetworkRequestOptions.get();
      expect(options.method, 'GET');
    });

    test('POST', () async {
      final options = NetworkRequestOptions.post();
      expect(options.method, 'POST');
    });

    test('PUT', () async {
      final options = NetworkRequestOptions.put();
      expect(options.method, 'PUT');
    });

    test('PATCH', () async {
      final options = NetworkRequestOptions.patch();
      expect(options.method, 'PATCH');
    });

    test('DELETE', () async {
      final options = NetworkRequestOptions.delete();
      expect(options.method, 'DELETE');
    });
  });
}
