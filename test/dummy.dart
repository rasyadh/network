import 'package:faker/faker.dart';
import 'package:network/network.dart';

class Dummy {
  static NetworkResponse createNetworkResponse(Faker faker) {
    return NetworkResponse(
      data: faker.lorem.sentence(),
      headers: {
        faker.lorem.word(): faker.lorem.words(3),
        faker.lorem.word(): faker.lorem.words(3),
      },
      requestOptions: createNetworkRequestOptions(faker),
      statusCode: faker.randomGenerator.integer(600),
      statusMessage: faker.lorem.sentence(),
      extra: <String, dynamic>{
        faker.lorem.word(): faker.lorem.word(),
        faker.lorem.word(): faker.lorem.word(),
      },
    );
  }

  static NetworkRequestOptions createNetworkRequestOptions(Faker faker) {
    return NetworkRequestOptions(
        path: faker.internet.httpsUrl(),
        headers: {
          faker.lorem.word(): faker.lorem.word(),
          faker.lorem.word(): faker.lorem.word(),
          'content-type': 'application/json; charset=utf-8'
        },
        timeout: faker.randomGenerator.integer(100),
        data: faker.lorem.sentence(),
        queryParameters: {
          faker.lorem.word(): faker.lorem.word(),
          faker.lorem.word(): faker.lorem.word(),
        },
        extra: <String, dynamic>{
          faker.lorem.word(): faker.lorem.word(),
          faker.lorem.word(): faker.lorem.word(),
        },
        method: faker.lorem.word());
  }
}
