import 'dart:io';

import 'package:flutter_file_upload/flutter_file_upload.dart';
import 'package:gx_file_picker/gx_file_picker.dart';

void pickAndUpload(Function(double) onProgress) async {
  File file = await FilePicker.getFile();
  print(file.path);
  FileService.upload(
      file: file,
      url: "http://10.0.2.2:3000/upload/testID",
      onUploadProgress: (sent, total) {
        onProgress(sent / total);
      });
}
