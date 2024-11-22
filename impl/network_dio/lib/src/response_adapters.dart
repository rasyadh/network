import 'package:network/network.dart';
import 'package:dio/dio.dart' as dio;
import 'package:network_dio/src/request_options_adapters.dart';

extension ToDioResponseTransform<T> on NetworkResponse<T> {
  dio.Response<T> toDioResponse() {
    final extraDioResponse = dio.Response<T>(
      data: data,
      headers: dio.Headers.fromMap(headers),
      requestOptions: requestOptions.toDioOptions(),
      statusCode: statusCode,
      statusMessage: statusMessage,
      extra: extra,
    );
    return extraDioResponse;
  }
}

extension FromDioResponseTransform<T> on dio.Response<T> {
  NetworkResponse<T> toNetworkResponse() {
    final extraNetworkResponse = NetworkResponse<T>(
      data: data,
      headers: headers.map,
      requestOptions: requestOptions.toNetworkRequestOptions(),
      statusCode: statusCode,
      statusMessage: statusMessage,
      extra: extra,
    );
    return extraNetworkResponse;
  }
}
