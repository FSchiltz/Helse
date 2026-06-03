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
  List<Pair<MetricType, OrderedItem>>? types;
  @override
  void initState() {
    super.initState();

    if (widget.group.showOnDashboard == true) {
      _getData();
    } else {
      setState(() {
        types = [];
      });
    }
  }

  void _getData() async {
    try {
      var model = await Dependencies.services.metric.metricsType(
        false,
        widget.group.id,
      );
      if (model != null) {
        var settings = await Dependencies.logics.settings.getMetrics();
        // filter using the user settings

        List<Pair<MetricType, OrderedItem>> filtered = [];
        for (var item in model.where((x) => x.showOnDashboard == true)) {
          OrderedItem setting =
              settings.firstWhereOrNull((element) => element.id == item.id) ??
              Dependencies.logics.settings.getDefault(item);

          if (setting.visible == true) filtered.add(Pair(item, setting));
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

    Widget body;

    body = cached == null
        ? const HelseLoader()
        : BlocListener<SettingsBloc<bool>, bool>(
            listener: (context, state) {
              _getData();
            },
            bloc: Dependencies.logics.settings.metrics,
            child: (cached.isNotEmpty)
                ? MetricWidgetsGrid(
                    date: widget.date,
                    person: widget.person,
                    cached: cached,
                    button: _openAll(context),
                  )
                : _openAll(context),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.group.showTitle == true ||
            widget.group.showOnDashboard != true)
          Text(
            widget.group.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        body,
        SizedBox(height: 12),
        Divider(height: 4),
        SizedBox(height: 32),
      ],
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
