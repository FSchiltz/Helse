import 'package:flutter/material.dart';
import 'package:helse/ui/common/ui_constants.dart';

import 'blocs/care/agenda.dart';
import 'blocs/care/patients.dart';

class CareDashBoard extends StatelessWidget {
  const CareDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    var isMobile = UIHelpers.isMobile(context);

    var theme = Theme.of(context).colorScheme;

    if (isMobile) {
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  Padding(padding: const EdgeInsets.all(8.0), child: Agenda()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Patients(),
                  ),
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(icon: Icon(Icons.edit_calendar_sharp)),
                Tab(icon: Icon(Icons.personal_injury_sharp)),
              ],
            ),
          ],
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: theme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Patients(),
            ),
          ),
          Expanded(
            child: Padding(padding: const EdgeInsets.all(8.0), child: Agenda()),
          ),
        ],
      );
    }
  }
}
