import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/inputs/values_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/inputs/file_input.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';

class FileImport extends StatefulWidget {
  final int? patient;
  const FileImport({super.key, this.patient});

  @override
  State<FileImport> createState() => _FileImportState();
}

class _FileImportState extends State<FileImport> {
  List<FileType> types = [];
  XFile? file;
  int? selected;
  SubmissionStatus status = SubmissionStatus.initial;

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
      actions: [
        status == SubmissionStatus.inProgress
            ? const HelseLoader()
            : SquareButton(locale.submit, () => submit(locale)),
      ],
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

  void submit(AppLocalizations locale) async {
    var localContext = context;
    if (selected != null) {
      setState(() {
        status = SubmissionStatus.inProgress;
      });

      try {
        var content = await file?.readAsBytes();
        if (content == null) return;
        await Dependencies.logics.import.import(
          content,
          selected!,
          widget.patient,
        );

        setState(() {
          status = SubmissionStatus.success;
        });

        Notify.show("Imported");
        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }
      } catch (ex) {
        Notify.showError(locale.error(ex.toString()));

        setState(() {
          status = SubmissionStatus.failure;
        });
      }
    }
  }
}
