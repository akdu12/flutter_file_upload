import 'dart:async';
import 'dart:html';

import 'package:flutter_file_upload/comon.dart';

class FileService {
  static Future<dynamic> uploadWithMultipart(
      {required dynamic file,
      required String url,
      OnUploadProgressCallback? onUploadProgress,
      Map<String, String>? headers}) async {
    final request = HttpRequest();
    final formData = FormData();
    formData.appendBlob('file', file);

    request.upload.onProgress.listen((event) {
      if (request.readyState != 4 && onUploadProgress != null) {
        onUploadProgress(event.loaded ?? 0, event.total ?? 1);
      }
    });
    request.open('POST', url);
    if (headers != null && headers.isNotEmpty) {
      for (final header in headers.entries) {
        request.setRequestHeader(header.key, header.value);
      }
    }
    request.send(formData);
    await request.onLoadEnd.first;
    if (request.status == 200) {
      return request.response;
    }
  }

  static Future<dynamic> upload(
      {required dynamic file,
      required String url,
      OnUploadProgressCallback? onUploadProgress,
      Map<String, String>? headers}) async {
    final request = HttpRequest();
    final formData = FormData();
    formData.appendBlob('file', file);

    request.upload.onProgress.listen((event) {
      if (request.readyState != 4 && onUploadProgress != null) {
        onUploadProgress(event.loaded ?? 0, event.total ?? 1);
      }
    });
    request.open('POST', url);
    if (headers != null && headers.isNotEmpty) {
      for (final header in headers.entries) {
        request.setRequestHeader(header.key, header.value);
      }
    }
    request.send(file);
    await request.onLoadEnd.first;
    if (request.status == 200) {
      return request.response;
    }
  }
}
