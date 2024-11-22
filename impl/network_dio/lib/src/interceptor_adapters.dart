import 'package:network_dio/network_dio.dart';

extension ToDioInterceptor on NetworkInterceptor {
  Interceptor toDioInterceptor() {
    final networkIntercept = this;
    return NetworkInterceptorsWrapper(onRequest: (options, handler) {
      // handler.next(options);
      networkIntercept.onRequest(
          options.toNetworkRequestOptions(),
          NetworkRequestInterceptorHandler(onNext: (request) {
            final newOptions = request.toDioOptions();
            handler.next(newOptions);
          }, onReject: (ex) {
            final cause = ex.cause;
            if (cause is DioException) {
              handler.reject(cause);
            }
          }));
    }, onResponse: (response, handler) {
      // handler.next(response);
      networkIntercept.onResponse(
          response.toNetworkResponse(),
          NetworkResponseInterceptorHandler(onNext: (response) {
            handler.next(response.toDioResponse());
          }, onReject: (ex) {
            final cause = ex.cause;
            if (cause is DioException) {
              handler.reject(cause);
            }
          }));
    }, onError: (DioException e, handler) {
      networkIntercept.onError(
          InterceptorRelatedException(
              technicalMessage: e.message ?? "",
              cause: e), NetworkErrorInterceptorHandler(onReject: (ex) {
        final cause = ex.cause;
        if (cause is DioException) {
          handler.reject(cause);
        }
      }));
    });
  }
}

class NetworkInterceptorsWrapper extends Interceptor {
  final InterceptorSendCallback? __onRequest;

  final InterceptorSuccessCallback? __onResponse;

  final InterceptorErrorCallback? __onError;

  NetworkInterceptorsWrapper({
    InterceptorSendCallback? onRequest,
    InterceptorSuccessCallback? onResponse,
    InterceptorErrorCallback? onError,
  })  : __onRequest = onRequest,
        __onResponse = onResponse,
        __onError = onError;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    __onError?.call(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    __onResponse?.call(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    __onRequest?.call(options, handler);
  }
}
