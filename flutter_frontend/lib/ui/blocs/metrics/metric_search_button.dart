import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_search.dart';

class MetricSearchButton extends StatelessWidget {
  final MetricType type;
  final int? person;
  const MetricSearchButton(this.type, {super.key, this.person});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: IconButton(
        onPressed: () => _open(context),
        icon: const Icon(Icons.search_sharp),
      ),
    );
  }

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MetricSearch(type, person: person),
      ),
    );
  }
}
