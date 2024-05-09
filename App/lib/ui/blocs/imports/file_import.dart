import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/theme/square_dialog.dart';

import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../common/file_input.dart';
import '../../theme/loader.dart';
import '../../theme/notification.dart';

class FileImport extends StatefulWidget {
  const FileImport({super.key});

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
    var model = await DI.helper.fileTypes();
    if (model != null) {
      setState(() {
        types = model;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SquareDialog(
      title: const Text("Import"),
      actions: [
        status == SubmissionStatus.inProgress
            ? const HelseLoader()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: const ContinuousRectangleBorder(),
                ),
                onPressed: submit,
                child: const Text('Submit'),
              ),
      ],
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text("Import external metric",
                style: Theme.of(context).textTheme.bodyMedium),
            DropdownButtonFormField(
              onChanged: (value) => setState(() {
                selected = value;
              }),
              items: types
                  .map((type) => DropdownMenuItem(
                      value: type.type, child: Text(type.name ?? "")))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Type',
                prefixIcon: Icon(Icons.list_sharp),
              ),
            ),
            const SizedBox(height: 10),
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

  void submit() async {
    var localContext = context;
    if (selected != null) {
      setState(() {
        status = SubmissionStatus.inProgress;
      });

      try {
        var content = await file?.readAsString();
        if (content == null) return;
        await DI.helper.import(content, selected!);

        setState(() {
          status = SubmissionStatus.success;
        });

        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }

        Notify.show("Imported");
      } catch (ex) {
        Notify.showError("$ex");

        setState(() {
          status = SubmissionStatus.failure;
        });
      }
    }
  }
}
