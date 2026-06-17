import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/care/patient_menu.dart';
import 'package:helse/ui/blocs/care/patients_dashboard.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class PatientsCard extends StatelessWidget {
  final Person person;
  final void Function() callback;
  const PatientsCard(this.person, this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return CommonCard(
      padding: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => PatientsDashboard(person, 0),
                ),
              ),
              child: Row(
                children: [
                  Container(
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
                ],
              ),
            ),
          ),
          PatientMenu(person, callback),
        ],
      ),
    );
  }
}
