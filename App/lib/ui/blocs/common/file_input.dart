import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

import 'text_input.dart';

class FileInput extends StatelessWidget {
  final void Function(XFile value) callback;
  final String label;
  final IconData icone;
  final TextEditingController _controller = TextEditingController();

  FileInput(this.callback, this.label, this.icone, {super.key});

  Future<void> _pickFile() async {
    final XFile? file = await openFile();
    if (file != null) {
      callback(file);
      _controller.text = file.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(
      icone,
      label,
      onTap: _pickFile,
      textController: _controller,
    );
  }
}
