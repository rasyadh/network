import 'package:network/network.dart';
import 'package:dio/dio.dart' as dio;
import 'response_type_adapter.dart';

extension ToDioTransform on NetworkRequestOptions {
  dio.RequestOptions toDioOptions() {
    Duration? timeoutDuration;
    final t = timeout;
    if (t != null) {
      timeoutDuration = Duration(milliseconds: t);
    }
    dio.RequestOptions extraDioOption = dio.RequestOptions(
      path: path,
      headers: headers,
      connectTimeout: timeoutDuration,
      receiveTimeout: timeoutDuration,
      sendTimeout: timeoutDuration,
      data: data,
      queryParameters: queryParameters,
      extra: extra,
      method: method,
      responseType: responseType.toDioResponseType(),
    );
    return extraDioOption;
  }
}

extension FromDioTransform on dio.RequestOptions {
  NetworkRequestOptions toNetworkRequestOptions() {
    NetworkRequestOptions extraNetworkOption = NetworkRequestOptions(
      path: path,
      headers: headers,
      timeout: connectTimeout?.inMilliseconds,
      data: data,
      queryParameters: queryParameters,
      extra: extra,
      method: method,
      responseType: responseType.toNetworkResponseType(),
    );
    return extraNetworkOption;
  }
}

extension MapMerger<T, Y> on Map<T, Y> {
  /// Create a new map copy with all entries from this and the [otherMap]
  /// If [otherMap]'s entries already exists, it will overwrite the old one.
  Map<T, Y> mergedWith(Map<T, Y> otherMap) {
    Map<T, Y> newMap = Map.from(this);
    newMap.addAll(otherMap);
    return newMap;
  }
}
