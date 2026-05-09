import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/care/patient_add.dart';
import 'package:helse/ui/blocs/care/patients_dashboard.dart';
import 'package:helse/ui/blocs/care/share_patient_dialog.dart';

class PatientsCard extends StatelessWidget {
  final Person person;
  final void Function() callback;
  const PatientsCard(this.person, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: person.profilePicture != null
              ? Image.memory(
                  base64Decode(person.profilePicture!),
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.person_sharp,
                  size: 40,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
        ),
        const SizedBox(width: 8),
        Text(
          person.name ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          person.surname ?? "",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => PatientsDashboard(person),
            ),
          ),
          icon: Icon(Icons.visibility_sharp, color: theme.primary),
        ),
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return PatientAdd(callback, edit: person);
              },
            );
          },
          icon: Icon(Icons.edit_sharp, color: theme.primary),
        ),
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return SharePatientDialog(person);
              },
            );
          },
          icon: Icon(Icons.share_sharp, color: theme.primary),
        ),
      ],
    );
  }
}
