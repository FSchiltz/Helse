import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/ui/common/inputs/file_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

class UIFile {
  final XFile? file;
  final String name;
  final int? id;

  UIFile(this.file, this.name, this.id);
}

class FileListWidget extends StatelessWidget {
  final List<UIFile> files;
  final void Function(List<UIFile>) callback;
  final String label;

  const FileListWidget({
    super.key,
    required this.files,
    required this.callback,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FileInput(
          (value) {
            files.add(UIFile(value, value.name, null));
            callback(files);
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
                  files.removeAt(index);
                  callback(files);
                },
              ),
            );
          }),
        ],
      ],
    );
  }
}
