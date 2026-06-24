import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_add.dart';

class MetricAddButton extends StatelessWidget {
  final MetricType type;
  final void Function() callback;
  final int? person;
  const MetricAddButton(this.type, this.callback, {super.key, this.person});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return MetricAdd(type, callback, person: person);
            },
          );
        },
        icon: const Icon(Icons.add_sharp),
      ),
    );
  }
}
