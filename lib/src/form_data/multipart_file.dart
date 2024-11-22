import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;

/// A file to be uploaded as part of a [MultipartRequest]. This doesn't need to
/// correspond to a physical file.
///
/// MultipartFile is based on stream, and a stream can be read only once,
/// so the same MultipartFile can't be read multiple times.
class FormMultipartFile {
  /// The size of the file in bytes. This must be known in advance, even if this
  /// file is created from a [ByteStream].
  final int length;

  /// The basename of the file. May be null.
  final String? filename;

  /// The additional headers the file has. May be null.
  final Map<String, List<String>>? headers;

  /// The content-type of the file. Defaults to `application/octet-stream`.
  final String? contentType;

  /// The stream that will emit the file's contents.
  final Stream<List<int>> stream;

  /// Creates a new [FormMultipartFile] from a chunked [Stream] of bytes. The length
  /// of the file in bytes must be known in advance. If it's not, read the data
  /// from the stream and use [MultipartFile.fromBytes] instead.
  ///
  /// [contentType] currently defaults to `application/octet-stream`
  FormMultipartFile(this.stream, this.length,
      {this.filename,
      this.headers,
      this.contentType = "application/octet-stream"});

  /// Creates a new [FormMultipartFile] from a byte array.
  ///
  /// [contentType] currently defaults to `application/octet-stream`, but in the
  /// future may be inferred from [filename].
  factory FormMultipartFile.fromBytes(
    List<int> value, {
    String? filename,
    String? contentType,
    final Map<String, List<String>>? headers,
  }) {
    var stream = Stream.fromIterable([value]);
    return FormMultipartFile(
      stream,
      value.length,
      filename: filename,
      contentType: contentType,
      headers: headers,
    );
  }

  /// Creates a new [FormMultipartFile] from a path to a file on disk.
  ///
  /// [filename] defaults to the basename of [filePath]. [contentType] currently
  /// defaults to `application/octet-stream`, but in the future may be inferred
  /// from [filename].
  ///
  /// Throws an [UnsupportedError] if `dart:io` isn't supported in this
  /// environment.
  static Future<FormMultipartFile> fromFile(
    String filePath, {
    String? filename,
    String? contentType,
    final Map<String, List<String>>? headers,
  }) async {
    filename ??= p.basename(filePath);
    var file = File(filePath);
    var length = await file.length();
    var stream = file.openRead();
    return FormMultipartFile(
      stream,
      length,
      filename: filename,
      contentType: contentType,
      headers: headers,
    );
  }
}
