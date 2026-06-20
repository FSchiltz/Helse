import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/care/patient_add.dart';
import 'package:helse/ui/blocs/care/patients_card.dart';
import 'package:helse/ui/common/hamburger_menu.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/ui_constants.dart';
import 'package:helse/ui/patient_settings.dart';

import 'blocs/care/agenda.dart';

class CareDashBoard extends StatelessWidget {
  const CareDashBoard({super.key});

  Future<List<Person>> _getData(bool refresh) async =>
      await Dependencies.services.user.patients() ?? [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UIConstants.formPad),
      child: LoadingBuilder(
        _getData,
        builder: (context, data, reset) {
          final isMobile = UIHelpers.isMobile(context);
          final double maxWidth = 300;
          final double maxHeight = 250;
          return LayoutBuilder(
            builder: (context, constraints) => Wrap(
              children: [
                SizedBox(
                  width: (isMobile)
                      ? constraints.maxWidth
                      : constraints.maxWidth - maxWidth,
                  height: (isMobile) ? maxHeight : constraints.maxHeight,
                  child: Agenda(data, compact: isMobile),
                ),
                SizedBox(
                  width: (isMobile) ? constraints.maxWidth : maxWidth,
                  height: (isMobile)
                      ? constraints.maxHeight - maxHeight
                      : constraints.maxHeight,
                  child: Column(
                    children: [
                      _getHeader(context, reset, data),
                      Expanded(
                        child: ListView(
                          children: data
                              .map((e) => PatientsCard(e, reset))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getHeader(
    BuildContext context,
    void Function() reset,
    List<Person> data,
  ) {
    var locale = Translation.of(context);
    var theme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(locale.patients, style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(width: UIConstants.formPad),
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) => PatientAdd(reset),
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
    );
  }
}
