import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/files/file_input.dart';
import 'package:helse/ui/common/inputs/files/file_item.dart';
import 'package:helse/ui/common/inputs/files/file_list_picker.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/ui_constants.dart';

class UIFile {
  XFile? file;
  final String name;
  final String description;
  int? id;

  UIFile(this.file, this.name, this.id, this.description);
}

class FileListWidget extends StatelessWidget {
  final List<UIFile> files;
  final void Function(UIFile, List<UIFile>) onAdd;
  final void Function(UIFile, List<UIFile>) onDelete;
  final void Function(UIFile) onTap;
  final bool readonly;
  final int? person;

  const FileListWidget({
    super.key,
    required this.files,
    required this.onAdd,
    required this.onDelete,
    required this.onTap,
    this.readonly = false,
    this.person,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return Column(
      children: [
        if (!readonly)
          Row(
            children: [
              Flexible(
                child: FileInput((value) {
                  // first check that the file is not already added
                  final exists = files.any((e) => e.file?.path == value.path);
                  if (!exists) {
                    final file = UIFile(value, value.name, null, '');
                    files.add(file);
                    onAdd(file, files);
                  }
                }, locale.upload),
              ),

              Flexible(
                child: SquareButton(locale.fromExisting, () async {
                  final file = await showDialog<UIFile?>(
                    context: context,
                    builder: (BuildContext context) {
                      return FileListPicker(person);
                    },
                  );

                  if (file != null) {
                    final exists = files.any((e) => e.id == file.id);
                    if (!exists) {
                      files.add(file);
                      onAdd(file, files);
                    }
                  }
                }),
              ),
            ],
          ),

        if (files.isNotEmpty)
          ...files.asMap().entries.map(
            (entry) => FileItem(
              file: entry.value,
              onDelete: readonly
                  ? null
                  : () {
                      final deleted = files[entry.key];
                      files.removeAt(entry.key);
                      onDelete(deleted, files);
                    },
              onTap: () => onTap(entry.value),
            ),
          ),
      ],
    );
  }
}
