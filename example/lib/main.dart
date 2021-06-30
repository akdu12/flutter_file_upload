import 'package:flutter/material.dart';

import 'web.dart' if (dart.library.io) "mobile.dart";

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
              onPressed: () => pickAndUpload((progress) {
                {
                  setState(() {
                    _progress = progress;
                  });
                }
              }),
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
}
