import 'package:file_selector/file_selector.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/inputs/file_list_widget.dart';
import 'package:http/http.dart';

class FileHelper {
  static Future<MultipartFile> extract(XFile file) async {
    var content = await file.readAsBytes();
    return MultipartFile.fromBytes("file", content, filename: 'upload');
  }

  static Future<void> syncFiles(
    Iterable<UIFile> fileToAdd,
    Set<int> toDelete,
    int? person,
    Future<void> Function(int fileId) link,
    Future<void> Function(int fileId) unlink,
    void Function(double progress, String status) callback,
  ) async {
    var i = 0;
    final total = fileToAdd.length + toDelete.length;
    for (var file in fileToAdd) {
      callback(i / total * 100, "Uploading File ${file.name}");

      var fileId = file.id;

      if (fileId == null) {
        fileId = await Dependencies.services.files.postFile(file, person) ?? 0;

        file.id = fileId;
      }

      if (file.file != null) {
        await Dependencies.services.files.postFileData(
          fileId,
          file.file!,
          person,
        );

        file.file = null;
      }

      await link(fileId);

      i++;
    }

    for (var file in toDelete) {
      callback(i / total * 100, "Unlinking Files");

      // we don't delete file, only unlink them
      await unlink(file);
    }
  }
}
