import 'package:dio/dio.dart';
import 'package:network/network.dart';

extension FromDioResponseTypeTransform on ResponseType {
  NetworkResponseType toNetworkResponseType() {
    switch (this) {
      case ResponseType.plain:
        return NetworkResponseType.plain;
      case ResponseType.json:
        return NetworkResponseType.json;
      case ResponseType.stream:
        return NetworkResponseType.stream;
      case ResponseType.bytes:
        return NetworkResponseType.bytes;
    }
  }
}

extension ToDioResponseTypeTransform on NetworkResponseType {
  ResponseType toDioResponseType() {
    switch (this) {
      case NetworkResponseType.plain:
        return ResponseType.plain;
      case NetworkResponseType.json:
        return ResponseType.json;
      case NetworkResponseType.stream:
        return ResponseType.stream;
      case NetworkResponseType.bytes:
        return ResponseType.bytes;
    }
  }
}
