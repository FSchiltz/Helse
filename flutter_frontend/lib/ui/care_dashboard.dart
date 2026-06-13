import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/ui_constants.dart';

import 'blocs/care/agenda.dart';
import 'blocs/care/patients.dart';

class CareDashBoard extends StatelessWidget {
  const CareDashBoard({super.key});

  Future<List<Person>> _getData(bool refresh) async {
    return await Dependencies.services.user.patients() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = UIHelpers.isMobile(context);

    var theme = Theme.of(context).colorScheme;

    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        if (isMobile) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Patients(data, reset),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Agenda(data),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.personal_injury_sharp)),
                    Tab(icon: Icon(Icons.edit_calendar_sharp)),
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
                  child: Patients(data, reset),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Agenda(data),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
