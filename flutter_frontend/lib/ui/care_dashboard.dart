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

    return Padding(
      padding: const EdgeInsets.all(UIConstants.formPad),
      child: LoadingBuilder(
        _getData,
        builder: (context, data, reset) {
          if (isMobile) {
            return Column(
              children: [
                Flexible(child: Agenda(data)),
                Divider(),
                Flexible(child: SingleChildScrollView(child: Patients(data, reset))),
              ],
            );
          } else {
            return Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: theme.surfaceContainer,
                  child: Patients(data, reset),
                ),
                Expanded(
                  child: SizedBox(width: 320, child: Agenda(data)),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
