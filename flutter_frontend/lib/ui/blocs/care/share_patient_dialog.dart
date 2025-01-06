import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';

import '../../../logic/d_i.dart';
import '../../../logic/event.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';
import '../../common/square_dialog.dart';
import '../../common/statefull_check.dart';
import '../../common/type_input.dart';

class SharePatientDialog extends StatefulWidget {
  final Person patient;

  const SharePatientDialog(this.patient, {super.key});

  @override
  State<SharePatientDialog> createState() => _SharePatientDialogState();
}

class _SharePatientDialogState extends State<SharePatientDialog> {
  Future<List<Person>>? _caregivers;
  int caregiver = 0;
  bool edit = false;
  SubmissionStatus _status = SubmissionStatus.initial;

  Future<List<Person>> _getCaregiver() {
    return DI.user.caregiver();
  }

  @override
  void initState() {
    super.initState();
    _caregivers = _getCaregiver();
  }

  @override
  Widget build(BuildContext context) {
    return SquareDialog(
      title: Text("Share ${widget.patient.name} ${widget.patient.surname}"),
      content: FutureBuilder(
          future: _caregivers,
          builder: (context, snapshot) {
            // Checking if future is resolved
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
                // if we got our data
              } else if (snapshot.hasData) {
                var caregivers = snapshot.data as List<Person>;

                return Column(children: [
                  ..._shareForm(caregivers, widget.patient),
                  _status == SubmissionStatus.inProgress
                      ? const HelseLoader()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: const ContinuousRectangleBorder(),
                          ),
                          onPressed: _submit,
                          child: const Text('Share'),
                        ),
                ]);
              }
            }

            return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }

  List<Widget> _shareForm(List<Person> caregivers, Person patient) => [
        TypeInput(
            label: 'Caregiver',
            caregivers.map((x) => DropDownItem(x.id, x.userName ?? '')).toList(),
            (value) => setState(() {
                  caregiver = value ?? 0;
                })),
        const SizedBox(height: 10),
        Row(children: [
          const Text("With edit right: "),
          StatefullCheck(
              edit,
              (value) => setState(() {
                    edit = value;
                  }))
        ])
      ];

  void _submit() async {
    var localContext = context;
    try {
      setState(() {
        _status = SubmissionStatus.inProgress;
      });

      try {
        // save the user
        var patient = widget.patient.id;
        if (patient == null) {
          throw Exception();
        }

        await DI.user.sharePatient(patient: patient, caregiver: caregiver, edit: edit);

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
}
