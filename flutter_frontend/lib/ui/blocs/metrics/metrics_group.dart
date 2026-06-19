import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/ui/blocs/metrics/metric_group_detail.dart';
import 'package:helse/ui/blocs/metrics/metric_widgets_grid.dart';

import '../../../di/dependencies.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';

class MetricsGroup extends StatefulWidget {
  final int? person;
  final MetricGroup group;
  final DateTimeRange date;

  const MetricsGroup({
    super.key,
    required this.date,
    required this.group,
    this.person,
  });

  @override
  State<MetricsGroup> createState() => _MetricsGroupState();
}

class _MetricsGroupState extends State<MetricsGroup> {
  List<(MetricType, OrderedItem)>? types;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      List<MetricType>? model;

      model = await Dependencies.services.metric.metricsType(
        false,
        widget.group.id,
      );

      if (model != null) {
        MetricSettings settings;

        if (widget.person == null) {
          settings = Dependencies.logics.settings.getMetrics();
        } else {
          settings = Dependencies.logics.patientsSettings.getMetrics(
            widget.person,
          );
        }
        
        // filter using the user settings
        List<(MetricType, OrderedItem)> filtered = [];
        for (var item in model.where((x) => x.showOnDashboard == true)) {
          OrderedItem setting =
              settings.displaySettings.firstWhereOrNull(
                (element) => element.id == item.id,
              ) ??
              Dependencies.logics.settings.getDefault(item);

          if (setting.showOnDashboard == true) {
            filtered.add((item, setting));
          }
        }

        setState(() {
          types = filtered;
        });
      }
    } catch (ex) {
      Notify.showError("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var cached = types;

    var color = Dependencies.theme.stateColor(
      "${widget.group.id}",
      StateType.metricGroup,
      context,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 6),
              Text(
                widget.group.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(width: 12),
              _openAll(context),
            ],
          ),
          cached == null
              ? const HelseLoader()
              : BlocListener<SettingsBloc<bool>, bool>(
                  listener: (context, state) {
                    _getData();
                  },
                  bloc: Dependencies.logics.settings.metrics,
                  child: MetricWidgetsGrid(
                    date: widget.date,
                    person: widget.person,
                    cached: cached,
                    tile: 60,
                  ),
                ),
        ],
      ),
    );
  }

  IconButton _openAll(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) =>
              MetricGroupDetail(widget.date, widget.person, widget.group),
        ),
      ),
      icon: const Icon(Icons.open_in_new_sharp),
    );
  }
}
