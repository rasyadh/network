import 'dart:convert';

import 'package:network/src/request_options.dart';

/// Response describes the http Response info.
class NetworkResponse<T> {
  NetworkResponse({
    required this.data,
    Map<String, List<String>>? headers,
    required this.requestOptions,
    this.statusCode,
    this.statusMessage,
    Map<String, dynamic>? extra,
  }) {
    this.headers = headers ?? <String, List<String>>{};
    this.extra = extra ?? {};
  }

  /// Response body
  T? data;

  /// Response headers.
  late Map<String, List<String>> headers;

  /// The corresponding request info.
  late NetworkRequestOptions requestOptions;

  /// Http status code.
  int? statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  String? statusMessage;

  /// Custom field that you can retrieve it later in `then`.
  late Map<String, dynamic> extra;

  /// We are more concerned about `data` field.
  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}

extension HeaderShortcuts on NetworkResponse {
  int? get contentLength {
    String contentLength = headers["content-length"]?.first ??
        headers["Content-Length"]?.first ??
        "";
    if (contentLength.isEmpty) {
      return null;
    }
    return int.tryParse(contentLength);
  }
}

typedef NetworkStringResponse = NetworkResponse<String>;
