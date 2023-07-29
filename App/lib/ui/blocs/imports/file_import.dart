import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/import/import_bloc.dart';

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
  String? fileName;

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
    return BlocProvider(
        create: (context) {
          return ImportBloc();
        },
        child: BlocListener<ImportBloc, ImportState>(
            listener: (context, state) {
              if (state.status == SubmissionStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Upload Failure')),
                  );
              }
            },
            child: AlertDialog(
              scrollable: true,
              title: const Text("Import"),
              actions: [
                _SubmitButton(),
              ],
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Text("Import external metric", style: Theme.of(context).textTheme.bodyMedium),
                        _TypeInput(types),
                        const SizedBox(height: 10),
                        _FileInput((XFile x) => setState(() {
                              fileName = x.name;
                            })),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(fileName ?? ""),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}

class _FileInput extends StatelessWidget {
  final void Function(XFile x) callback;

  const _FileInput(this.callback);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportBloc, ImportState>(
      buildWhen: (previous, current) => previous.file?.name != current.file?.name,
      builder: (context, state) {
        return FileInput(
          (value) {
            context.read<ImportBloc>().add(FileChangedEvent(value, ImportBloc.fileEvent));
            callback(value);
          },
          "File",
          Icons.upload_file_sharp,
        );
      },
    );
  }
}

class _TypeInput extends StatelessWidget {
  final List<FileType> types;
  const _TypeInput(this.types);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportBloc, ImportState>(
      buildWhen: (previous, current) => previous.type != current.type,
      builder: (context, state) {
        return DropdownButtonFormField(
          onChanged: (value) => context.read<ImportBloc>().add(IntChangedEvent(value ?? 0, ImportBloc.typeEvent)),
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
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportBloc, ImportState>(
      builder: (context, state) {
        return state.status == SubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: state.isValid
                    ? () {
                        context.read<ImportBloc>().add(SubmittedEvent("", callback: () => Navigator.of(context).pop()));
                      }
                    : null,
                child: const Text('Submit'),
              );
      },
    );
  }
}
