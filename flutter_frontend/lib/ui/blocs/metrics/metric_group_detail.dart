import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widgets_grid.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/notification.dart';

class MetricGroupDetail extends StatefulWidget {
  final DateTimeRange<DateTime> date;
  final int? person;
  final Group group;

  const MetricGroupDetail(this.date, this.person, this.group, {super.key});

  @override
  State<MetricGroupDetail> createState() => _MetricGroupDetailState();
}

class _MetricGroupDetailState extends State<MetricGroupDetail> {
  List<(MetricType, OrderedItem)>? types;

  void _getData() async {
    try {
      var model = await Dependencies.services.metric.metricsType(
        false,
        widget.group.id,
      );
      if (model != null) {
        List<(MetricType, OrderedItem)> filtered = [];
        MetricSettings settings;

        if (widget.person == null) {
          settings = Dependencies.logics.settings.getMetrics();
        } else {
          settings = Dependencies.logics.patientsSettings.getMetrics(
            widget.person,
          );
        }

        for (var item in model) {
          OrderedItem setting =
              settings.displaySettings.firstWhereOrNull(
                (element) => element.id == item.id,
              ) ??
              Dependencies.logics.settings.getDefault(item);

          if (setting.visible == true) {
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
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    var cached = types;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          widget.group.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: cached == null
          ? const HelseLoader()
          : LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: BlocListener<SettingsBloc<bool>, bool>(
                  listener: (context, state) {
                    _getData();
                  },
                  bloc: Dependencies.logics.settings.metrics,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MetricWidgetsGrid(
                      cached: cached,
                      person: widget.person,
                      date: widget.date,
                      extend: constraints.maxWidth,
                      fullWidth: true,
                      tile: 200,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
