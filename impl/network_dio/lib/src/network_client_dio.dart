import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:network/network.dart';
import 'interceptor_adapters.dart';
import 'request_options_adapters.dart';
import 'response_adapters.dart';

class NetworkClientDioHttp2 with NetworkClientDio implements NetworkClient {
  NetworkClientDioHttp2() {
    dioClient.httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: const Duration(seconds: 10),
        // Ignore bad certificate
        onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
      ),
    );
  }
}

class NetworkClientDioHttp1 with NetworkClientDio implements NetworkClient {
  NetworkClientDioHttp1();
}

mixin NetworkClientDio implements NetworkClient {
  @protected
  @visibleForTesting
  final dio.Dio dioClient = dio.Dio();

  /// basePath, appended to all incomplete uri
  late String baseUrl = '';

  void _applyBaseUrl(NetworkOptions options) {
    if (!options.path.contains("://")) {
      options.path = baseUrl + options.path;
    }
  }

  @override
  void addInterceptor(NetworkInterceptor interceptor) {
    dioClient.interceptors.add(interceptor.toDioInterceptor());
  }

  @override
  Future<Result<NetworkStringResponse>> request(
      NetworkRequestOptions options) async {
    try {
      _applyBaseUrl(options);

      final response = await dioClient.fetch<String>(options.toDioOptions());
      Future<Result<NetworkStringResponse>> processed =
          _processResponse(response);
      return processed;
    } catch (ex) {
      return _processException(ex);
    }
  }

  @override
  FutureResult<NetworkResponse<Stream<Uint8List>>> download(
      NetworkRequestOptions options, savePath,
      {NetworkProgressCallback? onReceiveProgress,
      Completer<StandardException>? cancelToken}) async {
    // final stopwatch = Stopwatch()..start();
    try {
      _applyBaseUrl(options);

      final dioCancelToken = dio.CancelToken();

      cancelToken?.future.then((value) => {dioCancelToken.cancel(value)});

      final response = await dioClient.download(options.path, savePath,
          queryParameters: options.queryParameters.isNotEmpty
              ? options.queryParameters
              : null,
          onReceiveProgress: onReceiveProgress,
          cancelToken: dioCancelToken);

      Result<NetworkResponse<Stream<Uint8List>>> processed =
          await _processResponse(response);
      return processed;
    } catch (ex) {
      return _processException(ex);
    }
  }

  @override
  FutureResult<NetworkStringResponse> upload(NetworkRequestOptions options,
      {NetworkProgressCallback? onSendProgress,
      Completer<StandardException>? cancelToken}) async {
    // final stopwatch = Stopwatch()..start();
    try {
      _applyBaseUrl(options);

      if (options.method != "POST" && options.method != "PUT") {
        options.method = "POST";
      }

      dio.Options uploadOptions = dio.Options(
          extra: options.extra,
          method: options.method,
          headers: options.headers);
      dynamic uploadData = options.data;

      Map<String, dynamic> rawMap = {};
      // Priority is: options.data, then options.queryParameters.
      // if any value is FormMultipartFile, it's' converted to the library class
      if (uploadData is FormMultipartFile) {
        // Switch out Network MultipartFile to Dio MultipartFile
        uploadData = uploadData.toDio();
      } else if (uploadData is Map<String, dynamic> && uploadData.isNotEmpty) {
        rawMap = uploadData;
      } else if (uploadData == null && options.queryParameters.isNotEmpty) {
        rawMap = options.queryParameters;
      }

      if (rawMap.isNotEmpty) {
        final entries = rawMap.entries.toList();
        Map<String, dynamic> map = {};
        for (var entry in entries) {
          var value = entry.value;

          // Convert FormMultipartFile to Dio.MultipartFile
          if (value is FormMultipartFile) {
            value = value.toDio();
          }
          map[entry.key] = value;
        }
        uploadData = dio.FormData.fromMap(map);
      }

      final dioCancelToken = dio.CancelToken();

      cancelToken?.future.then((value) => {dioCancelToken.cancel(value)});

      dio.Response<String> response = await dioClient.request(options.path,
          data: uploadData,
          options: uploadOptions,
          onSendProgress: onSendProgress);

      FutureResult<NetworkStringResponse> processed =
          _processResponse(response);

      return processed;
    } catch (ex) {
      return _processException(ex);
    }
  }

  FutureResult<NetworkResponse<T>> _processException<T>(dynamic ex) async {
    final error = ex.error;
    if (ex is dio.DioException) {
      final exResponse = ex.response;
      if (exResponse != null) {
        return _processResponse(exResponse);
      } else if (error is StandardException) {
        return Result.error(error);
      } else {
        return Result.error(ConnectionRelatedException(
            cause: ex, technicalMessage: ex.message ?? ""));
      }
    }
    return Result.error(ConnectionRelatedException(
        cause: ex, technicalMessage: ex.getInfoMessage()));
  }

  FutureResult<NetworkResponse<T>> _processResponse<T>(
      dio.Response response) async {
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 300) {
      var data = response.data;
      // SUCCESS
      if (data is dio.ResponseBody) {
        data = data.stream;
      }
      if (data is T) {
        return Result.value(NetworkResponse(
            data: data,
            headers: response.headers.map,
            requestOptions: response.requestOptions.toNetworkRequestOptions(),
            statusCode: response.statusCode,
            statusMessage: response.statusMessage));
      } else {
        // DATA ERROR
        return Result.error(BadDataException(
            technicalMessage: "Response Data type is not $T",
            technicalCode: statusCode.toString(),
            cause: response.toNetworkResponse()));
      }
    } else if (statusCode >= 400 && statusCode < 500) {
      // CLIENT ERROR
      return Result.error(ClientRelatedException(
          technicalMessage: response.statusMessage ?? "<empty status message>",
          technicalCode: statusCode.toString(),
          response: response.toNetworkResponse()));
    } else {
      // ASSUME OTHER CODE IS SERVER ERROR
      return Result.error(ServerRelatedException(
          technicalMessage: response.statusMessage ?? "<empty status message>",
          technicalCode: statusCode.toString(),
          response: response.toNetworkResponse()));
    }
  }
}

extension MultipartFileToDio on FormMultipartFile {
  dio.MultipartFile toDio() {
    final contentType = this.contentType;
    final value = dio.MultipartFile.fromStream(
      () => stream,
      length,
      filename: filename,
      contentType: contentType != null ? MediaType.parse(contentType) : null,
      headers: headers,
    );
    return value;
  }
}
