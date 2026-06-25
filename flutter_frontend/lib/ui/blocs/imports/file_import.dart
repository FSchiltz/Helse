import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/inputs/values_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/inputs/file_input.dart';

class FileImport extends StatefulWidget {
  final int? patient;
  const FileImport({super.key, this.patient});

  @override
  State<FileImport> createState() => _FileImportState();
}

class _FileImportState extends PopupSubmitState<FileImport> {
  List<FileType> types = [];
  XFile? file;
  int? selected;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var model = await Dependencies.services.import.fileTypes();
    if (model != null) {
      setState(() {
        types = model;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Import"),
      actions: [submitButton(locale.submit, _submit)],
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text(
              "Import external metric",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ValuesInput(
              types
                  .map((type) => DropdownItem(type.type, type.name ?? ""))
                  .toList(),
              (value) => setState(() {
                selected = value;
              }),
              label: 'Type',
            ),
            const SizedBox(height: UIConstants.formPad),
            FileInput(
              (value) {
                setState(() {
                  file = value;
                });
              },
              "File",
              Icons.upload_file_sharp,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(file?.name ?? ""),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (selected != null) {
      var content = await file?.readAsBytes();
      if (content == null) return;
      await Dependencies.logics.import.import(
        content,
        selected!,
        widget.patient,
      );
    }
  }
}
