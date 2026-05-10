import 'package:flutter/material.dart';

import 'blocs/care/agenda.dart';
import 'blocs/care/patients.dart';

class CareDashBoard extends StatelessWidget {
  const CareDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Agenda(),
          ),
        ),
      ],
    );
  }
}
