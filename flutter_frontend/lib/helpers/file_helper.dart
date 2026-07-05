import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart';

class FileHelper {
  static Future<MultipartFile> extract(XFile file) async {
    var content = await file.readAsBytes();
    return MultipartFile.fromBytes("file", content, filename: 'upload');
  }
}
