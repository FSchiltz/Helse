import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../events/events_graph.dart';

class TreatmentsGrid extends StatefulWidget {
  const TreatmentsGrid({super.key, required this.date, this.person});

  final DateTimeRange date;
  final int? person;

  @override
  State<TreatmentsGrid> createState() => _TreatmentsGridState();
}

class _TreatmentsGridState extends State<TreatmentsGrid> {
  Future<List<Treatment>> _getData(bool refresh) async {
    var date = widget.date;

    var start = DateTime(date.start.year, date.start.month, date.start.day);
    var end = DateTime(
      date.end.year,
      date.end.month,
      date.end.day,
    ).add(const Duration(days: 1));

    return await DI.treatement?.treatments(start, end, person: widget.person) ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (ctx, data, context) {
        return ListView(
          shrinkWrap: true,
          children: data
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EventGraph(
                    e.events ?? List<Event>.empty(),
                    widget.date,
                    (e) => {},
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
