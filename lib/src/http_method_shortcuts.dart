import 'dart:async';

import 'package:json_converter/json_converter.dart';
import 'package:network/src/extra/extra_perf_tracking.dart';
import 'network_response.dart';

import 'network_client.dart';
import 'network_exceptions.dart';
import 'progress_callback.dart';
import 'request_options.dart';

extension HttpJsonMethodShortcuts on NetworkClient {
  FutureResult<T> get<T>(
    T Function(Map<String, dynamic>) decoder,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    void Function(NetworkResponse response)? onResponseProcessingFinished,
  }) async {
    return jsonRequest(
      decoder,
      NetworkRequestOptions(
        method: "get",
        path: path,
        headers: header,
        queryParameters: queryParameters,
      ),
      onResponseProcessingFinished: onResponseProcessingFinished,
    );
  }

  FutureResult<T> post<T>(
    T Function(Map<String, dynamic>) decoder,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    void Function(NetworkResponse response)? onResponseProcessingFinished,
  }) async {
    return jsonRequest(
      decoder,
      NetworkRequestOptions(
        method: "post",
        path: path,
        headers: header,
        queryParameters: queryParameters,
      ),
      onResponseProcessingFinished: onResponseProcessingFinished,
    );
  }

  FutureResult<T> patch<T>(
    T Function(Map<String, dynamic>) decoder,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    void Function(NetworkResponse response)? onResponseProcessingFinished,
  }) async {
    return jsonRequest(
      decoder,
      NetworkRequestOptions(
        method: "patch",
        path: path,
        headers: header,
        queryParameters: queryParameters,
      ),
      onResponseProcessingFinished: onResponseProcessingFinished,
    );
  }

  FutureResult<T> put<T>(
    T Function(Map<String, dynamic>) decoder,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    void Function(NetworkResponse response)? onResponseProcessingFinished,
  }) async {
    return jsonRequest(
      decoder,
      NetworkRequestOptions(
        method: "put",
        path: path,
        headers: header,
        queryParameters: queryParameters,
      ),
      onResponseProcessingFinished: onResponseProcessingFinished,
    );
  }

  FutureResult<T> delete<T>(
    T Function(Map<String, dynamic>) decoder,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? header,
    void Function(NetworkResponse response)? onResponseProcessingFinished,
  }) async {
    return jsonRequest(
      decoder,
      NetworkRequestOptions(
        method: "delete",
        path: path,
        headers: header,
        queryParameters: queryParameters,
      ),
      onResponseProcessingFinished: onResponseProcessingFinished,
    );
  }

  FutureResult<T> jsonRequest<T>(
    T Function(Map<String, dynamic>) decoder,
    NetworkRequestOptions options, {
    void Function(NetworkResponse response)? onResponseProcessingFinished,
  }) async {
    try {
      final rawResponse = await request(options);

      bool forceIsolate = false;
      await rawResponse.onValue((t) async {
        if ((t.contentLength ?? 0) >= 10000) {
          forceIsolate = true;
        }
      });

      return rawResponse.mapAsync((networkResponse) async {
        final data = networkResponse.data;
        if (data != null) {
          final stopwatch = Stopwatch()..start();
          final decoded = jsonConverter.decode(
            data,
            forceIsolate: forceIsolate,
          );
          networkResponse.parseTime = (stopwatch..stop()).elapsedMilliseconds;
          onResponseProcessingFinished?.call(networkResponse);
          return decoded;
        }
        return Result.error(
          BadDataException(
            technicalMessage: 'data is null',
            cause: networkResponse,
          ),
        );
      }).map((value) async {
        try {
          final decoded = decoder(value);
          return Result.value(decoded);
        } catch (ex) {
          return Result.error(
            FailDecoderException(
              technicalMessage: "Decoder failed on type: $T and map $value",
              cause: ex,
            ),
          );
        }
      }, (error) {
        return error;
      });
    } catch (exception) {
      return Result.error(exception);
    }
  }

  FutureResult<T> jsonRequestUpload<T>(
    T Function(Map<String, dynamic>) decoder,
    NetworkRequestOptions options,
    NetworkProgressCallback? onSendProgress,
    Completer<StandardException>? cancelToken, {
    void Function(NetworkResponse response)? onResponseProcessingFinished,
  }) async {
    try {
      final rawResponse = await upload(
        options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return rawResponse.mapAsync((response) async {
        final data = response.data;
        if (data != null) {
          final decoded = jsonConverter.decode(data);
          onResponseProcessingFinished?.call(response);
          return decoded;
        }
        return Result.error(
          BadDataException(
            technicalMessage: 'data is null',
            cause: response,
          ),
        );
      }).map((value) async {
        try {
          final decoded = decoder(value);
          return Result.value(decoded);
        } catch (ex) {
          return Result.error(
            FailDecoderException(
              technicalMessage: "Decoder failed on type: $T and map $value",
              cause: ex,
            ),
          );
        }
      });
    } catch (exception) {
      return Result.error(exception);
    }
  }
}
