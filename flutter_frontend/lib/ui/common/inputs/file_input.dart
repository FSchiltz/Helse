import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:helse/ui/common/square_button.dart';

class FileInput extends StatelessWidget {
  final void Function(XFile value) callback;
  final String label;
  final IconData icone;

  const FileInput(this.callback, this.label, this.icone, {super.key});

  Future<void> _pickFile() async {
    final XFile? file = await openFile();
    if (file != null) {
      callback(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SquareButton(label, _pickFile, icon: icone);
  }
}
