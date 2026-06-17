import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../logic/event.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../administration/users/user_form.dart';
import '../../common/loader.dart';

class PatientAdd extends StatefulWidget {
  final void Function() callback;
  final Person? edit;
  const PatientAdd(this.callback, {super.key, this.edit});

  @override
  State<PatientAdd> createState() => _PatientAddState();
}

class _PatientAddState extends State<PatientAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  SubmissionStatus _status = SubmissionStatus.initial;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNiss = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();

  Uint8List? _pictureData;

  Future<void> _selectPicture() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(label: 'images', extensions: ['png', 'jpg', 'jpeg', 'gif']),
      ],
    );
    if (file != null) {
      _pictureData = await file.readAsBytes();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    var edit = widget.edit;
    if (edit != null) {
      _controllerName.text = edit.name ?? '';
      _controllerSurname.text = edit.surname ?? '';
      _controllerNiss.text = edit.identifier ?? '';

      if (edit.profilePicture != null) {
        _pictureData = base64Decode(edit.profilePicture ?? '');
      }
    }
  }

  void _submit(AppLocalizations locale) async {
    var localContext = context;
    try {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });
      try {
        if (widget.edit != null) {
          await Dependencies.services.user.updatePatient(
            UpdatePatient(
              id: widget.edit?.id,
              name: _controllerName.text,
              surname: _controllerSurname.text,
              identifier: _controllerNiss.text,
              profilePicture: _pictureData != null
                  ? base64Encode(_pictureData!)
                  : null,
            ),
          );
        } else {
          // save the user
          await Dependencies.services.user.addPerson(
            PersonCreation(
              name: _controllerName.text,
              surname: _controllerSurname.text,
              identifier: _controllerNiss.text,
              types: [],
              profilePicture: _pictureData != null
                  ? base64Encode(_pictureData!)
                  : null,
            ),
          );
        }

        _formKey.currentState?.reset();
        widget.callback.call();
        if (localContext.mounted) {
          Navigator.of(localContext).pop();
          Notify.show(locale.added);
        }

        setState(() {
          _status = SubmissionStatus.success;
        });
      } catch (_) {
        setState(() {
          _status = SubmissionStatus.failure;
        });
      }
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.add),
      actions: [
        _status == SubmissionStatus.inProgress
            ? const HelseLoader()
            : SquareButton(locale.submit, () => _submit(locale)),
      ],
      content: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  locale.addPatients,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: UIConstants.formPad),
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _selectPicture,
                        child: Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              color: Theme.of(context).colorScheme.surface,
                              child: _pictureData != null
                                  ? Image.memory(
                                      _pictureData!,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.image_sharp,
                                      size: 40,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                child: Icon(
                                  Icons.add_sharp,
                                  size: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: UIConstants.formPad),
                    ],
                  ),
                ),
                UserForm(
                  [],
                  controllerName: _controllerName,
                  controllerSurname: _controllerSurname,
                  controllerIdentifier: _controllerNiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
