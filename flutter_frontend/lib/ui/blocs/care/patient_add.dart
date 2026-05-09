import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_dialog.dart';

import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../administration/users/user_form.dart';
import '../../common/loader.dart';

class PatientAdd extends StatefulWidget {
  final void Function() callback;
  const PatientAdd(this.callback, {super.key});

  @override
  State<PatientAdd> createState() => _PatientAddState();
}

class _PatientAddState extends State<PatientAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  SubmissionStatus _status = SubmissionStatus.initial;

  final TextEditingController _controllerName = TextEditingController();

  final TextEditingController _controllerSurname = TextEditingController();

  Uint8List? _pictureData;
  String? _pictureName;

  Future<void> _selectPicture() async {
    final XFile? file = await openFile(acceptedTypeGroups: [XTypeGroup(label: 'images', extensions: ['png', 'jpg', 'jpeg', 'gif'])]);
    if (file != null) {
      _pictureData = await file.readAsBytes();
      _pictureName = file.name;
      setState(() {});
    }
  }

  void _submit() async {
    var localContext = context;
    try {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });
      try {
        // save the user
        await DI.user.addPerson(PersonCreation(
          name: _controllerName.text,
          surname: _controllerSurname.text,
          types: [],
          profilePicture: _pictureData != null ? base64Encode(_pictureData!) : null,
        ));

        _formKey.currentState?.reset();
        widget.callback.call();
        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }

        Notify.show("Added succesfully");

        setState(() {
          _status = SubmissionStatus.success;
        });
      } catch (_) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
      }
    } catch (ex) {
      Notify.showError("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SquareDialog(
      title: const Text("Add"),
      actions: [
        _status == SubmissionStatus.inProgress
            ? const HelseLoader()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: const ContinuousRectangleBorder(),
                ),
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: _submit,
                child: const Text('Submit'),
              ),
      ],
      content: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Add a new patient",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          child: _pictureData != null
                              ? ClipOval(
                                  child: Image.memory(
                                    _pictureData!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.person_sharp,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _pictureName == null ? 'No picture selected' : _pictureName!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _selectPicture,
                          icon: const Icon(Icons.image_sharp),
                          label: const Text('Choose picture'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: const ContinuousRectangleBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  UserForm([],
                      controllerName: _controllerName,
                      controllerSurname: _controllerSurname),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
