import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

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
    return ElevatedButton.icon(
      onPressed: _pickFile,
      icon: Icon(icone),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: const ContinuousRectangleBorder(),
      ),
    );
  }
}
