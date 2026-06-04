import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/care/patient_add.dart';
import 'package:helse/ui/blocs/care/share_patient_dialog.dart';
import 'package:helse/ui/blocs/imports/file_import.dart';
import 'package:helse/ui/common/hamburger_menu.dart';
import 'package:helse/ui/patient_settings.dart';

class PatientMenu extends StatelessWidget {
  final Person person;
  final void Function() callback;
  const PatientMenu(this.person, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.locale(context);
    return HamburgerMenu(
      items: [
        MenuButton(locale.edit, Icons.edit_sharp, () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return PatientAdd(callback, edit: person);
            },
          );
        }),

        MenuButton(locale.share, Icons.share_sharp, () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return SharePatientDialog(person);
            },
          );
        }),

        MenuButton(locale.import, Icons.upload_file_sharp, () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return FileImport(patient: person.id);
            },
          );
        }),

        MenuButton(locale.patientsSettings, Icons.edit_sharp, () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => PatientSettingsPage(person.id),
            ),
          );
        }),
      ],
    );
  }
}
