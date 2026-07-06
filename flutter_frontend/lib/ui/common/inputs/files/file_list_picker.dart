import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/files/file_item.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/square_button.dart';

class FileListPicker extends StatefulWidget {
  final int? person;
  const FileListPicker(this.person, {super.key});

  @override
  State<FileListPicker> createState() => _FileListPickerState();
}

class _FileListPickerState extends State<FileListPicker> {
  List<UIFile>? _files;
  UIFile? _selected;

  Future<void> _getFileList() async {
    final result = await Dependencies.services.files.getFiles(widget.person);

    final xfiles = result
        .map((e) => UIFile(null, e.name, e.id, e.description))
        .toList();

    setState(() {
      _files = xfiles;
    });
  }

  @override
  void initState() {
    _getFileList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return SquareDialog(
      actions: [
        SquareButton(locale.ok, () => Navigator.pop(context, _selected)),
      ],
      content: _files == null
          ? HelseLoader()
          : Column(
              children: _files!
                  .map(
                    (entry) => FileItem(
                      selected: entry.id == _selected?.id,
                      file: entry,
                      onDelete: null,
                      onTap: () => _selected = entry,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
