import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:helse/services/file_service.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';

class FileLogic {
  final FileService files;
  FileLogic(this.files);

  Future<MultipartFile> extract(XFile file) async {
    var content = await file.readAsBytes();
    return MultipartFile.fromBytes("file", content, filename: 'upload');
  }

  Future<void> syncFiles(
    Iterable<UIFile> fileToAdd,
    Iterable<int> toDelete,
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
        await files.postFileData(fileId, file.file!, person);

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

  Future<void> download(int id, String fileName, int? person) async {
    final file = await files.getData(id, person);
    if (file == null) {
      return;
    }

    bool open = false;
    String? path;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      path = '/storage/emulated/0/Download${Platform.pathSeparator}$id-$fileName';
      open = true;
    } else {
      final FileSaveLocation? result = await getSaveLocation(
        suggestedName: fileName,
      );

      path = result?.path;
    }

    if (path == null) {
      // Operation was canceled by the user.
      return;
    }

    final Uint8List fileData = Uint8List.fromList(base64.decode(file.data));
    final XFile textFile = XFile.fromData(
      fileData,
      mimeType: file.type,
      name: fileName,
    );
    await textFile.saveTo(path);
    Notify.showIcon(NotificationKind.success);

    if (open) await OpenFile.open(path);
  }
}
