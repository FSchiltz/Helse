import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/ui/blocs/metrics/metric_group_detail.dart';
import 'package:helse/ui/blocs/metrics/metric_widgets_grid.dart';

import '../../../helpers/pair.dart';
import '../../../di/dependencies.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/loader.dart';
import '../../common/notification.dart';

class MetricsGroup extends StatefulWidget {
  final int? person;
  final MetricGroup group;
  final DateTimeRange date;
  final List<MetricType>? typesCache;

  const MetricsGroup({
    super.key,
    required this.date,
    required this.group,
    this.person,
    this.typesCache,
  });

  @override
  State<MetricsGroup> createState() => _MetricsGroupState();
}

class _MetricsGroupState extends State<MetricsGroup> {
  List<Pair<MetricType, OrderedItem>>? types;

  List<MetricType>? _cache;
  @override
  void initState() {
    super.initState();

    _cache = widget.typesCache;

    _getData();
  }

  void _getData() async {
    try {
      List<MetricType>? model;

      if (_cache != null) {
        model = widget.typesCache;
        _cache = null;
      } else {
        model = await Dependencies.services.metric.metricsType(
          false,
          widget.group.id,
        );
      }

      if (model != null) {
        List<OrderedItem> settings;

        if (widget.person == null) {
          settings = await Dependencies.logics.settings.getMetrics();
        } else {
          settings = await Dependencies.logics.patientsSettings.getMetrics(
            widget.person,
          );
        }
        // filter using the user settings

        List<Pair<MetricType, OrderedItem>> filtered = [];
        for (var item in model.where((x) => x.showOnDashboard == true)) {
          OrderedItem setting =
              settings.firstWhereOrNull((element) => element.id == item.id) ??
              Dependencies.logics.settings.getDefault(item);

          if (setting.showOnDashboard == true) {
            filtered.add(Pair(item, setting));
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
    var theme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: theme.secondary, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
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
