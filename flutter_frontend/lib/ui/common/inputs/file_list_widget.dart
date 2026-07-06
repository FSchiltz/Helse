import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/ui/common/inputs/file_input.dart';
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
  final void Function(UIFile) onDownload;
  final String label;
  final bool readonly;

  const FileListWidget({
    super.key,
    required this.files,
    required this.onAdd,
    required this.onDelete,
    required this.label,
    required this.onDownload,
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!readonly)
          FileInput(
            (value) {
              // first check that the file is not already added
              final exists = files.any((e) => e.file?.path == value.path);
              if (!exists) {
                final file = UIFile(value, value.name, null, '');
                files.add(file);
                onAdd(file, files);
              }
            },
            label,
            Icons.upload_file_sharp,
          ),

        if (files.isNotEmpty) ...[
          const SizedBox(height: UIConstants.formPad),
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
              onDownload: () => onDownload(entry.value),
            ),
          ),
        ],
      ],
    );
  }
}

class FileItem extends StatelessWidget {
  const FileItem({
    super.key,
    required this.file,
    required this.onDelete,
    required this.onDownload,
  });

  final UIFile file;
  final void Function()? onDelete;
  final void Function() onDownload;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.insert_drive_file),
      title: Text(file.name),
      onTap: (file.id == null) ? null : () => onDownload(),
      trailing: (onDelete == null)
          ? null
          : IconButton(icon: const Icon(Icons.close), onPressed: onDelete),
    );
  }
}
