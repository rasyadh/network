import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:network_dio/network_dio.dart';

class NetworkNativeClientDio with NetworkClientDio implements NetworkClient {
  NetworkNativeClientDio({
    CronetEngine Function()? createCronetEngine,
    URLSessionConfiguration Function()? createCupertinoConfiguration,
  }) {
    httpClientAdapter = NativeAdapter(
      createCronetEngine: createCronetEngine,
      createCupertinoConfiguration: createCupertinoConfiguration,
    );
    dioClient.httpClientAdapter = httpClientAdapter;
  }

  late HttpClientAdapter httpClientAdapter;
}
