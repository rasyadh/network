import 'response_type.dart';

class NetworkRequestOptions {
  String path;
  dynamic data;
  late Map<String, dynamic> queryParameters;
  NetworkResponseType responseType;

  NetworkRequestOptions({
    this.path = "",
    this.data,
    this.method = "GET",
    queryParameters,
    this.timeout,
    extra,
    headers,
    this.responseType = NetworkResponseType.plain,
  }) {
    this.queryParameters = queryParameters ?? {};
    this.headers = headers ?? {};
    this.extra = extra ?? {};
  }

  /// Http method.
  String method;

  /// Http request headers. The keys of initial headers will be converted to lowercase,
  /// for example 'Content-Type' will be converted to 'content-type'.
  ///
  /// The key of Header Map is case-insensitive, eg: content-type and Content-Type are
  /// regard as the same key.
  late Map<String, dynamic> headers;

  /// Timeout in milliseconds for request operation.
  int? timeout;

  /// Custom field that you can retrieve it later in [Interceptor]、[Transformer] and the [Response] object.
  late Map<String, dynamic> extra;

  /// shortcut for GET
  factory NetworkRequestOptions.get({
    String path = "",
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int? timeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
  }) {
    return NetworkRequestOptions(
        path: path,
        data: data,
        method: "GET",
        queryParameters: queryParameters,
        timeout: timeout,
        extra: extra,
        headers: headers);
  }

  /// shortcut for POST
  factory NetworkRequestOptions.post({
    String path = "",
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int? timeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
  }) {
    return NetworkRequestOptions(
        path: path,
        data: data,
        method: "POST",
        queryParameters: queryParameters,
        timeout: timeout,
        extra: extra,
        headers: headers);
  }

  /// shortcut for PUT
  factory NetworkRequestOptions.put({
    String path = "",
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int? timeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
  }) {
    return NetworkRequestOptions(
        path: path,
        data: data,
        method: "PUT",
        queryParameters: queryParameters,
        timeout: timeout,
        extra: extra,
        headers: headers);
  }

  /// shortcut for PATCH
  factory NetworkRequestOptions.patch({
    String path = "",
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int? timeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
  }) {
    return NetworkRequestOptions(
        path: path,
        data: data,
        method: "PATCH",
        queryParameters: queryParameters,
        timeout: timeout,
        extra: extra,
        headers: headers);
  }

  /// shortcut for DELETE
  factory NetworkRequestOptions.delete({
    String path = "",
    dynamic data,
    Map<String, dynamic>? queryParameters,
    int? timeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
  }) {
    return NetworkRequestOptions(
        path: path,
        data: data,
        method: "DELETE",
        queryParameters: queryParameters,
        timeout: timeout,
        extra: extra,
        headers: headers);
  }
}

/// easy shorthand. can be hidden if needed.
typedef NetworkOptions = NetworkRequestOptions;
