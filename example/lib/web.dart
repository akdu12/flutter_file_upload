import 'dart:html';

import 'package:flutter_file_upload/flutter_file_upload.dart';

void pickAndUpload(Function(double) onProgress) async {
  InputElement uploadInput = FileUploadInputElement();
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files.length == 1) {
      final file = files[0];
      FileService().upload(
          file: file,
          url: "http://localhost:3000/upload/testID",
          onUploadProgress: (sent, total) {
            onProgress(sent / total);
          });
    }
  });
}
