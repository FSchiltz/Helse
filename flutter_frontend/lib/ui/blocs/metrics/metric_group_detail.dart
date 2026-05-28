import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/helpers/pair.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_widgets_grid.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/notification.dart';

class MetricGroupDetail extends StatefulWidget {
  final DateTimeRange<DateTime> date;
  final int? person;
  final MetricGroup group;

  const MetricGroupDetail(this.date, this.person, this.group, {super.key});

  @override
  State<MetricGroupDetail> createState() => _MetricGroupDetailState();
}

class _MetricGroupDetailState extends State<MetricGroupDetail> {
  List<Pair<MetricType, OrderedItem>>? types;

  void _getData() async {
    try {
      var model = await DI.metric.metricsType(false, widget.group.id);
      if (model != null) {
        List<Pair<MetricType, OrderedItem>> filtered = [];
        for (var item in model) {
          OrderedItem setting = DI.settings.getDefault(item);

          filtered.add(Pair(item, setting));
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
          : BlocListener<SettingsBloc, bool>(
              listener: (context, state) {
                _getData();
              },
              bloc: DI.settings.metrics,
              child: MetricWidgetsGrid(
                cached: cached,
                person: widget.person,
                date: widget.date,
                extend: 400,
              ),
            ),
    );
  }
}
