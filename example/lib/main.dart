import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_file_upload/flutter_file_upload.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebFileUploadExample(),
    );
  }
}

class WebFileUploadExample extends StatefulWidget {
  @override
  State createState() => _WebFileUploadExample();
}

class _WebFileUploadExample extends State<WebFileUploadExample> {
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$_progress", style: TextStyle(color: Colors.black)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _startFilePicker,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue)),
              child: Text(
                "Upload A file",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startFilePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileService().upload(
            file: file,
            url: "http://localhost:3000/upload",
            onUploadProgress: (sent, total) {
              setState(() {
                _progress = sent / total;
              });
            });
      }
    });
  }
}
