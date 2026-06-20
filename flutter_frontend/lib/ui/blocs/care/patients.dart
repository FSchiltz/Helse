import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/care/patients_card.dart';
import 'package:helse/ui/common/hamburger_menu.dart';
import 'package:helse/ui/patient_settings.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'patient_add.dart';

class Patients extends StatelessWidget {
  final List<Person> data;
  final void Function() reset;
  const Patients(this.data, this.reset, {super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final cards = data.map((p) => PatientsCard(p, reset)).toList();
    var locale = Translation.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(
              locale.patients,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(width: 12),
            IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return PatientAdd(reset);
                  },
                );
              },
              icon: const Icon(Icons.add_sharp),
              iconSize: 35,
              color: theme.primary,
            ),
            Spacer(),
            HamburgerMenu(
              items: [
                MenuButton(locale.patientsSettings, Icons.edit_sharp, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          PatientSettingsPage(null, patients: data),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: cards,
        ),
      ],
    );
  }
}
