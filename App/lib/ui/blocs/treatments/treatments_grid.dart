import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';

import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../events/events_graph.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';

class TreatmentsGrid extends StatefulWidget {
  const TreatmentsGrid({super.key, required this.date, this.person});

  final DateTimeRange date;
  final int? person;

  @override
  State<TreatmentsGrid> createState() => _TreatmentsGridState();
}

class _TreatmentsGridState extends State<TreatmentsGrid> {
  List<Treatement>? _treatments;

  Future<List<Treatement>?> _getData() async {
    try {
      if (_treatments != null) return _treatments;

      var date = widget.date;

      var start = DateTime(date.start.year, date.start.month, date.start.day);
      var end = DateTime(date.end.year, date.end.month, date.end.day)
          .add(const Duration(days: 1));

      _treatments =
          await DI.treatement?.treatments(start, end, person: widget.person);
      return _treatments;
    } catch (ex) {
      Notify.showError("$ex");
    }
    return _treatments;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(),
        builder: (ctx, snapshot) {
          // Checking if future is resolved
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            }

            final events = (snapshot.hasData)
                ? snapshot.data as List<Treatement>
                : List<Treatement>.empty();

            return ListView(
              shrinkWrap: true,
              children: events
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: EventGraph(
                            e.events ?? List<Event>.empty(), widget.date, (e) => {}),
                      ))
                  .toList(),
            );
          }
          return const HelseLoader();
        });
  }
}
