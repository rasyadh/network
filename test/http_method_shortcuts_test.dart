import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_converter/json_converter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network/network.dart';
import 'package:faker/faker.dart';

class MockClient extends Mock implements NetworkClient {}

class Sample {
  Sample({
    required this.name,
    required this.age,
    required this.address,
  });
  late final String name;
  late final int age;
  late final String address;

  Sample.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['age'] = age;
    _data['address'] = address;
    return _data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sample &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age &&
          address == other.address;

  @override
  int get hashCode => name.hashCode ^ age.hashCode ^ address.hashCode;
}

void main() {
  final faker = Faker();
  late MockClient mockClient;
  late Sample sampleData;
  late NetworkStringResponse sampleResponse;

  setUpAll(() {
    registerFallbackValue(NetworkRequestOptions(path: ""));
  });

  setUp(() {
    mockClient = MockClient();
    sampleData = Sample(
        name: faker.person.name(),
        age: faker.randomGenerator.integer(100),
        address: faker.address.streetAddress());
    sampleResponse = NetworkResponse(
        data: jsonEncode(sampleData.toJson()),
        requestOptions: NetworkRequestOptions(path: ""));
  });

  group(NetworkClient, () {
    test('get and return invalid data', () async {
      var sampleBadResponse = NetworkResponse<String>(
          data: faker.lorem.sentence(), // invalid json
          requestOptions: NetworkRequestOptions(path: ""));
      when(() => mockClient.request(any()))
          .thenAnswer((_) => Future.value(Result.value(sampleBadResponse)));

      final result = await mockClient.get(Sample.fromJson, "path");

      expect(result.isError, true);
      expect(result.asError?.error, isA<JsonDecodeException>());
    });

    test('get and return bad decoder', () async {
      when(() => mockClient.request(any()))
          .thenAnswer((_) => Future.value(Result.value(sampleResponse)));

      final result = await mockClient.get((map) {
        throw Error();
      }, "path");

      expect(result.isError, true);
      expect(result.asError?.error, isA<FailDecoderException>());
    });

    test('get and return network exception', () async {
      when(() => mockClient.request(any()))
          .thenThrow(ConnectionRelatedException(technicalMessage: ""));

      final result = await mockClient.get(Sample.fromJson, "path");

      expect(result.isError, true);
      expect(result.asError?.error, isA<ConnectionRelatedException>());
    });

    test('get and return success response', () async {
      when(() => mockClient.request(any()))
          .thenAnswer((_) => Future.value(Result.value(sampleResponse)));

      final result = await mockClient.get(Sample.fromJson, "path");

      NetworkRequestOptions capturedOptions =
          verify(() => mockClient.request(captureAny())).captured.last;
      expect(capturedOptions.method, "get");
      expect(result.isValue, true);
      expect(sampleData, result.asValue?.value);
    });

    test('post and return success response', () async {
      when(() => mockClient.request(any()))
          .thenAnswer((_) => Future.value(Result.value(sampleResponse)));

      final result = await mockClient.post(Sample.fromJson, "path");

      NetworkRequestOptions capturedOptions =
          verify(() => mockClient.request(captureAny())).captured.last;
      expect(capturedOptions.method, "post");
      expect(result.isValue, true);
      expect(sampleData, result.asValue?.value);
    });

    test('patch and return success response', () async {
      when(() => mockClient.request(any()))
          .thenAnswer((_) => Future.value(Result.value(sampleResponse)));

      final result = await mockClient.patch(Sample.fromJson, "path");

      NetworkRequestOptions capturedOptions =
          verify(() => mockClient.request(captureAny())).captured.last;
      expect(capturedOptions.method, "patch");
      expect(result.isValue, true);
      expect(sampleData, result.asValue?.value);
    });

    test('put and return success response', () async {
      when(() => mockClient.request(any()))
          .thenAnswer((_) => Future.value(Result.value(sampleResponse)));

      final result = await mockClient.put(Sample.fromJson, "path");

      NetworkRequestOptions capturedOptions =
          verify(() => mockClient.request(captureAny())).captured.last;
      expect(capturedOptions.method, "put");
      expect(result.isValue, true);
      expect(sampleData, result.asValue?.value);
    });

    test('delete and return success response', () async {
      when(() => mockClient.request(any()))
          .thenAnswer((_) => Future.value(Result.value(sampleResponse)));

      final result = await mockClient.delete(Sample.fromJson, "path");

      NetworkRequestOptions capturedOptions =
          verify(() => mockClient.request(captureAny())).captured.last;
      expect(capturedOptions.method, "delete");
      expect(result.isValue, true);
      expect(sampleData, result.asValue?.value);
    });

    test('jsonRequestUpload and return ErrorResult', () async {
      Completer<StandardException> cancelToken = Completer();

      final request = await mockClient.jsonRequestUpload(Sample.fromJson,
          NetworkRequestOptions(), (count, total) {}, cancelToken);

      expect(request.asValue, null);
      expect(request.asError, isA<ErrorResult>());
    });

    test('jsonRequestUpload and return ValueResult', () async {
      Completer<StandardException> cancelToken = Completer();

      when(() => mockClient.upload(any(),
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: cancelToken))
          .thenAnswer((_) => Future.value(Result.value(sampleResponse)));

      final request = await mockClient.jsonRequestUpload(
        Sample.fromJson,
        NetworkRequestOptions(),
        (count, total) {},
        cancelToken,
      );

      expect(request.asValue, isA<ValueResult>());
      expect(request.asError, null);
    });
  });
}
