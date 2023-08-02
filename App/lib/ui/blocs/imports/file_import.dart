import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../../../logic/event.dart';
import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../common/file_input.dart';

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
    var model = await AppState.importLogic?.getType();
    if (model != null) {
      setState(() {
        types = model;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Import"),
      actions: [
        status == SubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: submit,
                child: const Text('Submit'),
              ),
      ],
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Text("Import external metric", style: Theme.of(context).textTheme.bodyMedium),
                DropdownButtonFormField(
                  onChanged: (value) => setState(() {
                    selected = value;
                  }),
                  items: types.map((type) => DropdownMenuItem(value: type.type, child: Text(type.name ?? ""))).toList(),
                  decoration: InputDecoration(
                    labelText: 'Type',
                    prefixIcon: const Icon(Icons.list_sharp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
        ),
      ),
    );
  }

  void submit() async {
    if (AppState.metricsLogic != null && selected != null) {
      setState(() {
        status = SubmissionStatus.inProgress;
      });

      try {
        var content = await file?.readAsString();
        if (content == null) return;
        await AppState.importLogic?.import(content, selected!);

        setState(() {
          status = SubmissionStatus.success;
        });
        
        Navigator.of(context).pop();
      } catch (ex) {
        setState(() {
          status = SubmissionStatus.failure;
        });
      }
    }
  }
}
