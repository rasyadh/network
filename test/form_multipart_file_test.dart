import 'dart:convert';
import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';
import 'package:path/path.dart' as p;

void main() {
  final faker = Faker();
  final sampleString = faker.lorem.sentence();
  const sampleFilename = "bukalapak.txt";
  final sampleHeaders = {
    "sample": ["1", "2"]
  };

  group(FormMultipartFile, () {
    test('FormMultipartFile.fromBytes', () async {
      List<int> bytes = utf8.encode(sampleString);
      final form = FormMultipartFile.fromBytes(bytes,
          filename: sampleFilename, headers: sampleHeaders);

      final decoded = utf8.decode(await form.stream
          .fold(<int>[], (previous, element) => previous..addAll(element)));
      expect(decoded, sampleString);
      expect(form.filename, sampleFilename);
      expect(form.headers, sampleHeaders);
      expect(form.contentType, null);
      expect(form.length, bytes.length);
    });

    test('FormMultipartFile.fromFile with filename', () async {
      List<int> bytes = utf8.encode(sampleString);

      const tempDir = "./test_temp";
      String tempPath = "$tempDir/$sampleFilename";
      File(tempPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);

      final form = await FormMultipartFile.fromFile(tempPath,
          filename: sampleFilename, headers: sampleHeaders);

      final decoded = utf8.decode(await form.stream
          .fold(<int>[], (previous, element) => previous..addAll(element)));
      expect(decoded, sampleString);
      expect(form.filename, sampleFilename);
      expect(form.headers, sampleHeaders);
      expect(form.contentType, null);
      expect(form.length, bytes.length);

      File(tempDir).deleteSync(recursive: true);
    });

    test('FormMultipartFile.fromFile with null filename', () async {
      List<int> bytes = utf8.encode(sampleString);

      const tempDir = "./test_temp";
      String tempPath = "$tempDir/some_path";
      File(tempPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);

      final form = await FormMultipartFile.fromFile(tempPath,
          filename: null, headers: sampleHeaders);

      final decoded = utf8.decode(await form.stream
          .fold(<int>[], (previous, element) => previous..addAll(element)));
      expect(decoded, sampleString);
      expect(form.filename, p.basename(tempPath));
      expect(form.headers, sampleHeaders);
      expect(form.contentType, null);
      expect(form.length, bytes.length);

      File(tempDir).deleteSync(recursive: true);
    });
  });
}
