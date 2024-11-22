import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:network_dio/network_dio.dart';

void main() async {
  final faker = Faker();

  group(NetworkClientDioHttp2, () {
    test('NetworkClientDioHttp2 uses Http2Adapter', () async {
      final client = NetworkClientDioHttp2().dioClient;
      expect(client.httpClientAdapter, isA<Http2Adapter>());
    });

    test('NetworkClientDioHttp1 uses default adapter', () async {
      final client = NetworkClientDioHttp1().dioClient;
      expect(client.httpClientAdapter, isA<IOHttpClientAdapter>());
    });
  });

  group(NetworkClientDio, () {
    late NetworkClientDio client;
    late Dio dio;
    late DioAdapter dioAdapter;
    late String url;
    late Map<String, dynamic> jsonObject;
    late String jsonString;
    late String rawString;

    setUp(() {
      client = NetworkClientDioHttp1();
      dio = client.dioClient;
      dioAdapter = DioAdapter(dio: dio);
      url = faker.internet.httpsUrl();
      jsonObject = {'message': 'Success!'};
      jsonString = jsonEncode(jsonObject);
      rawString = faker.lorem
          .sentences(100)
          .fold('', (previousValue, element) => previousValue + element);
    });

    test('request with statusCode >= 200 && statusCode < 300', () async {
      dioAdapter.onGet(
        url,
        (server) => server.reply(
            faker.randomGenerator.integer(299, min: 200), jsonObject),
      );

      final response = await client.request(NetworkRequestOptions(path: url));

      expect(response.isValue, true);
      expect(response.asValue?.value.data, jsonString);
    });

    test('request with statusCode >= 400 && statusCode < 500', () async {
      final statusCode = faker.randomGenerator.integer(499, min: 400);
      dioAdapter.onGet(
        url,
        (server) => server.reply(statusCode, jsonObject),
      );

      final response = await client.request(NetworkRequestOptions(path: url));

      expect(response.isError, true);
      expect(response.asError?.error, isA<ClientRelatedException>());
      final ex = tryCast<ClientRelatedException>(response.asError?.error);
      expect(ex?.technicalCode, statusCode.toString());
      expect(ex?.cause, isA<NetworkResponse>());
      expect(ex?.response.data, jsonString);
    });

    test('request with other statusCode', () async {
      final statusCode = faker.randomGenerator.integer(600, min: 500);
      dioAdapter.onGet(
        url,
        (server) => server.reply(statusCode, jsonObject),
      );

      final response = await client.request(NetworkRequestOptions(path: url));

      expect(response.isError, true);
      expect(response.asError?.error, isA<ServerRelatedException>());
      final ex = tryCast<ServerRelatedException>(response.asError?.error);
      expect(ex?.technicalCode, statusCode.toString());
      expect(ex?.cause, isA<NetworkResponse>());
      expect(ex?.response.data, jsonString);
    });

    test('download on success', () async {
      final statusCode = faker.randomGenerator.integer(299, min: 200);
      dioAdapter.onGet(
        url,
        (server) => server.reply(statusCode, rawString),
      );

      const sampleFilename = "bukalapak.txt";
      const tempDir = "./test_temp";
      String tempPath = "$tempDir/$sampleFilename";

      int updatedCount = 0;

      await client.download(NetworkRequestOptions(path: url), tempPath,
          onReceiveProgress: (count, total) {
        updatedCount++;
      });

      // check progress
      expect(updatedCount > 1, true);

      // check file
      final downloaded = File(tempPath);
      expect(downloaded.existsSync(), true);
      expect(downloaded.readAsStringSync(), "\"$rawString\"");

      // cleanup
      File(tempDir).deleteSync(recursive: true);
    });

    test('download on cancelled', () async {
      final statusCode = faker.randomGenerator.integer(299, min: 200);
      dioAdapter.onGet(
        url,
        (server) => server.reply(statusCode, rawString),
      );

      const sampleFilename = "bukalapak.txt";
      const tempDir = "./test_temp";
      String tempPath = "$tempDir/$sampleFilename";

      Completer<StandardException> cancelToken = Completer();
      var futureResult = client.download(
          NetworkRequestOptions(path: url), tempPath, cancelToken: cancelToken,
          onReceiveProgress: (count, total) {
        if (count > 100) {
          // cancel it when it's ongoing
          cancelToken.complete(RequestCancelledException());
        }
      });

      final result = await futureResult;

      // check progress
      expect(result.isError, true);
      expect(result.asError?.error, isA<RequestCancelledException>());
    });

    test('upload on success', () async {
      final statusCode = faker.randomGenerator.integer(299, min: 200);

      var multipartFile = FormMultipartFile.fromBytes(utf8.encode(rawString),
          contentType: "text/plain");

      dioAdapter.onPost(
          url, (server) => server.reply(statusCode, {'message': 'Success!'}),
          data: FormData.fromMap({
            'file': multipartFile.toDio(),
          }));

      final response = await client.upload(
          NetworkRequestOptions(path: url, queryParameters: {
            'file': multipartFile,
          }),
          onSendProgress: (count, total) {});

      // value returned
      expect(response.isValue, true);
    });
  });
}
