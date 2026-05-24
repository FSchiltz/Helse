import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/care/patients_card.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../logic/d_i.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'patient_add.dart';

class Patients extends StatelessWidget {
  const Patients({super.key});

  Future<List<Person>> _getData(bool refresh) async {
    return await DI.user.patients() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        final cards = data.map((p) => PatientsCard(p, reset)).toList();

        return SizedBox(
          width: 320,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Patients",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
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
                ],
              ),
              ListView(shrinkWrap: true, children: cards),
            ],
          ),
        );
      },
    );
  }
}
