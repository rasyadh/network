import '../network.dart';

class NetworkInterceptor {
  /// The callback will be executed before the request is initiated.
  ///
  /// If you want to continue the request, call [handler.next].
  ///
  /// If you want to complete the request with some custom data，
  /// you can resolve a [Response] object with [handler.resolve].
  ///
  /// If you want to complete the request with an error message,
  /// you can reject a [DioError] object with [handler.reject].
  void onRequest(
    NetworkRequestOptions options,
    NetworkRequestInterceptorHandler handler,
  ) =>
      handler.next(options);

  /// The callback will be executed on success.
  /// If you want to continue the response, call [handler.next].
  ///
  /// If you want to complete the response with some custom data directly,
  /// you can resolve a [Response] object with [handler.resolve] and other
  /// response interceptor(s) will not be executed.
  ///
  /// If you want to complete the response with an error message,
  /// you can reject a [DioError] object with [handler.reject].
  void onResponse(
    NetworkResponse response,
    NetworkResponseInterceptorHandler handler,
  ) =>
      handler.next(response);

  /// The callback will be executed on error.
  ///
  /// If you want to continue the error , call [handler.next].
  ///
  /// If you want to complete the response with some custom data directly,
  /// you can resolve a [Response] object with [handler.resolve] and other
  /// error interceptor(s) will be skipped.
  ///
  /// If you want to complete the response with an error message directly,
  /// you can reject a [DioError] object with [handler.reject], and other
  ///  error interceptor(s) will be skipped.
  void onError(
    NetworkException err,
    NetworkErrorInterceptorHandler handler,
  ) =>
      handler.next(err);
}

///  Simple observer on network traffic
abstract class NetworkObserver implements NetworkInterceptor {
  NetworkRequestOptions observeRequest(NetworkRequestOptions options);

  NetworkResponse observeResponse(
    NetworkResponse response,
  );

  @override
  void onError(NetworkException err, NetworkErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onRequest(
    NetworkRequestOptions options,
    NetworkRequestInterceptorHandler handler,
  ) {
    handler.next(observeRequest(options));
  }

  @override
  void onResponse(
    NetworkResponse response,
    NetworkResponseInterceptorHandler handler,
  ) {
    handler.next(observeResponse(response));
  }
}

/// Handler for request interceptor.
class NetworkRequestInterceptorHandler {
  void Function(NetworkRequestOptions)? onNext;
  void Function(NetworkException)? onReject;

  NetworkRequestInterceptorHandler({this.onNext, this.onReject});

  void next(NetworkRequestOptions requestOptions) {
    onNext?.call(requestOptions);
  }

  void reject(NetworkException error) {
    onReject?.call(error);
  }
}

/// Handler for response interceptor.
class NetworkResponseInterceptorHandler {
  void Function(NetworkResponse)? onNext;
  void Function(NetworkException)? onReject;

  NetworkResponseInterceptorHandler({this.onNext, this.onReject});

  void next(NetworkResponse response) {
    onNext?.call(response);
  }

  void reject(NetworkException error) {
    onReject?.call(error);
  }
}

/// Handler for error interceptor.
class NetworkErrorInterceptorHandler {
  void Function(NetworkException)? onReject;

  NetworkErrorInterceptorHandler({this.onReject});

  /// Continue to call the next error interceptor.
  void next(NetworkException err) {
    onReject?.call(err);
  }

  /// Complete the request with a error directly! Other error interceptor(s) will not be executed.
  void reject(NetworkException error) {
    onReject?.call(error);
  }
}
