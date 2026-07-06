import 'package:file_selector/file_selector.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/ui/common/inputs/file_list_widget.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:http/http.dart';

class FileLogic {
  final FileService files;
  FileLogic(this.files);

  Future<MultipartFile> extract(XFile file) async {
    var content = await file.readAsBytes();
    return MultipartFile.fromBytes("file", content, filename: 'upload');
  }

  Future<void> syncFiles(
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
        fileId = await files.postFile(file, person) ?? 0;

        file.id = fileId;
      }

      if (file.file != null) {
        await files.postFileData(
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

  Future<void> download(int? id, int? person) async {
    if (id == null) {
      return;
    }

    final file = await files.getData(id, person);
    Notify.show("Got mime type ${file?.type}");
  }
}
