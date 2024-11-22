import 'dart:async';
import 'dart:typed_data';

import 'package:network/network.dart';

abstract class NetworkClient {
  /// Intended for regular string/json http requests.
  /// [Options] the request option object which specifies the request.
  FutureResult<NetworkStringResponse> request(NetworkRequestOptions options);

  /// download file.
  FutureResult<NetworkResponse<Stream<Uint8List>>> download(
    NetworkRequestOptions options,
    savePath, {
    NetworkProgressCallback? onReceiveProgress,
    Completer<StandardException>? cancelToken,
  });

  FutureResult<NetworkStringResponse> upload(
    NetworkRequestOptions options, {
    NetworkProgressCallback? onSendProgress,
    Completer<StandardException>? cancelToken,
  });

  void addInterceptor(NetworkInterceptor interceptor);
}
