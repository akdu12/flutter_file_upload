library flutter_file_upload;

export 'platform/file_upload_web.dart' if (dart.library.io) 'platform/file_upload_mobile.dart';
