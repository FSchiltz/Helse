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
  final void Function(UIFile, List<UIFile>) addCallback;
  final void Function(UIFile, List<UIFile>) deleteCallback;
  final String label;

  const FileListWidget({
    super.key,
    required this.files,
    required this.addCallback,
    required this.deleteCallback,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FileInput(
          (value) {
            // first check that the file is not already added
            final exists = files.any((e) => e.file?.path == value.path);
            if (!exists) {
              final file = UIFile(value, value.name, null, '');
              files.add(file);
              addCallback(file, files);
            }
          },
          label,
          Icons.upload_file_sharp,
        ),

        if (files.isNotEmpty) ...[
          const SizedBox(height: UIConstants.formPad),

          ...files.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;

            return ListTile(
              dense: true,
              leading: const Icon(Icons.insert_drive_file),
              title: Text(file.name),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  final deleted = files[index];
                  files.removeAt(index);
                  deleteCallback(deleted, files);
                },
              ),
            );
          }),
        ],
      ],
    );
  }
}
