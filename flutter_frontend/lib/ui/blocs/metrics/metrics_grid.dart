import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/ui/blocs/metrics/metrics_group.dart';

import '../../../logic/d_i.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';

class MetricsGrid extends StatefulWidget {
  final int? person;
  const MetricsGrid({super.key, required this.date, this.person});

  final DateTimeRange date;

  @override
  State<MetricsGrid> createState() => _MetricsGridState();
}

class _MetricsGridState extends State<MetricsGrid> {
  List<MetricGroup>? types;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      var model = await DI.metric.metricsGroup();
      if (model != null) {
        // filter using the user settings

        setState(() {
          types = model;
        });
      }
    } catch (ex) {
      Notify.showError("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var cached = types;
    return cached == null
        ? const HelseLoader()
        : BlocListener<SettingsBloc, bool>(
            listener: (context, state) {
              _getData();
            },
            bloc: DI.settings.metrics,
            child: _getGrid(cached),
          );
  }

  StatelessWidget _getGrid(List<MetricGroup> cached) {
    if (cached.isEmpty) {
      return const Text("No metrics");
    } else {
      return GridView.extent(
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        physics: const BouncingScrollPhysics(),
        maxCrossAxisExtent: 200.0,
        children: cached
            .map(
              (type) => MetricsGroup(
                date: widget.date,
                key: Key(type.id?.toString() ?? ""),
                person: widget.person,
                group: type.id ?? 0,
              ),
            )
            .toList(),
      );
    }
  }
}
