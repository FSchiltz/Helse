import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

import 'text_input.dart';

class FileInput extends StatelessWidget {
  final void Function(XFile value) callback;

  const FileInput(this.callback, {super.key});

  Future<void> _pickFile() async {
    final XFile? file = await openFile();
    if (file != null) callback(file);
  }

  @override
  Widget build(BuildContext context) {
    return TextInput(Icons.design_services_outlined, "Tag", onTap: _pickFile);
  }
}
