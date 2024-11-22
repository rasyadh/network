import 'package:flutter_test/flutter_test.dart';
import 'package:network_dio/network_dio.dart';

void main() {
  group('ToDioTransform', () {
    test('toDioResponseType', () {
      expect(NetworkResponseType.plain.toDioResponseType(), ResponseType.plain);
      expect(
        NetworkResponseType.stream.toDioResponseType(),
        ResponseType.stream,
      );
      expect(NetworkResponseType.json.toDioResponseType(), ResponseType.json);
      expect(NetworkResponseType.bytes.toDioResponseType(), ResponseType.bytes);
    });

    test('toNetworkResponseType', () {
      expect(
        ResponseType.plain.toNetworkResponseType(),
        NetworkResponseType.plain,
      );
      expect(
        ResponseType.stream.toNetworkResponseType(),
        NetworkResponseType.stream,
      );
      expect(
        ResponseType.json.toNetworkResponseType(),
        NetworkResponseType.json,
      );
      expect(
        ResponseType.bytes.toNetworkResponseType(),
        NetworkResponseType.bytes,
      );
    });
  });
}
