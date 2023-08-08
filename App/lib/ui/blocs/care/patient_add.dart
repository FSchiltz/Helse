import 'package:flutter/material.dart';

import '../../../logic/event.dart';
import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../administration/user_form.dart';

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

  void _submit() async {
    setState(() {
      _status = SubmissionStatus.inProgress;
    });
    try {
      // save the user
      await AppState.authenticationLogic?.createAccount(
          person: PersonCreation(
        name: _controllerName.text,
        surname: _controllerSurname.text,
        type: UserType.patient,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 200,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text("Added Successfully"),
        ),
      );

      _formKey.currentState?.reset();
      widget.callback.call();
      Navigator.of(context).pop();
      setState(() {
        _status = SubmissionStatus.success;
      });
    } catch (_) {
      setState(() {
        _status = SubmissionStatus.failure;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      scrollable: true,
      title: const Text("Add"),
      actions: [
        SizedBox(
          width: 200,
          child: _status == SubmissionStatus.inProgress
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
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
                  Text("Add a new patient", style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  UserForm(UserType.patient, controllerName: _controllerName, controllerSurname: _controllerSurname),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
