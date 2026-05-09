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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: theme.surfaceContainerHigh,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => PatientsDashboard(person),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: theme.onPrimary, width: 1),
                ),
                child: SizedBox(
                  width: 60,
                  height: 60,
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
              ),
            ),
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
        ),
      ),
    );
  }
}
