import 'dart:async';
import 'dart:io';

import 'package:flutter_file_upload/comon.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as fileUtil;

class FileService {
  Future<HttpClientResponse> upload(
      {dynamic file,
      String url,
      OnUploadProgressCallback onUploadProgress,
      Map<String, String> headers}) async {
    assert(file != null);
    assert(url != null);

    final fileStream = file.openRead();
    int totalByteLength = file.lengthSync();
    final httpClient = HttpClient();
    final request = await httpClient.postUrl(Uri.parse(url));

    request.headers.set(HttpHeaders.contentTypeHeader, ContentType.binary);
    request.headers.add("filename", fileUtil.basename(file.path));

    if (headers != null && headers.isNotEmpty) {
      for (final header in headers.entries) {
        request.headers.set(header.key, header.value);
      }
    }

    request.contentLength = totalByteLength;

    int byteCount = 0;
    Stream<List<int>> streamUpload = fileStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          byteCount += data.length;

          if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
          }

          sink.add(data);
        },
        handleError: (error, stack, sink) {
          print(error.toString());
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    if (httpResponse.statusCode != 200) {
      throw Exception('Error uploading file');
    } else {
      return httpResponse;
    }
  }

  Future<HttpClientResponse> uploadWithMultipart(
      {dynamic file,
      String url,
      OnUploadProgressCallback onUploadProgress,
      Map<String, String> headers}) async {
    assert(file != null);
    assert(url != null);
    final httpClient = HttpClient();
    final request = await httpClient.postUrl(Uri.parse(url));

    var multipart = await http.MultipartFile.fromPath(
        fileUtil.basename(file.path), file.path);
    var requestMultipart = http.MultipartRequest("", Uri.parse("uri"));
    requestMultipart.files.add(multipart);

    var msStream = requestMultipart.finalize();

    var totalByteLength = requestMultipart.contentLength;
    request.contentLength = totalByteLength;

    request.headers.set(HttpHeaders.contentTypeHeader,
        requestMultipart.headers[HttpHeaders.contentTypeHeader]);
    if (headers != null && headers.isNotEmpty) {
      for (final header in headers.entries) {
        request.headers.set(header.key, header.value);
      }
    }
    int byteCount = 0;

    Stream<List<int>> streamUpload = msStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;

          if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
            // CALL STATUS CALLBACK;
          }
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    var statusCode = httpResponse.statusCode;

    if (statusCode ~/ 100 != 2) {
      throw Exception(
          'Error uploading file, Status code: ${httpResponse.statusCode}');
    } else {
      return httpResponse;
    }
  }
}
