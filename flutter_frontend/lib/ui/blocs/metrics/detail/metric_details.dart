import 'dart:developer' as logger;

import 'package:material_ui/material_ui.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/helpers/selection_controller.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/widget/widget_graph.dart';
import 'package:helse/ui/common/inputs/date_range_picker.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/navigator_chart.dart';

abstract class MetricDetails extends StatefulWidget {
  final DateTimeRange initialDate;
  final int? person;
  final MetricType type;
  final GraphKind settings;

  const MetricDetails(
    this.initialDate,
    this.settings, {
    super.key,
    this.person,
    required this.type,
  });
}

abstract class MetricDetailsState<T extends MetricDetails> extends State<T> {
  RangeList filteredMetrics = RangeList.empty();
  DateTimeRange selectedDate = DateHelper.now();
  DateTimeRange subDate = DateHelper.now();
  List<Metric> metrics = [];
  final SelectionController<Metric> selection = SelectionController();
  late double maxY;
  bool withStats = true;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    subDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (ctx, data, reset) {
        return buildContent(context, reset);
      },
    );
  }

  List<Metric> _filter(List<Metric> metrics, DateTimeRange<DateTime> value) {
    final stopwatch = Stopwatch()..start();
    logger.log('Filter for $value');
    var result = metrics
        .where((x) => x.date.isAfter(value.start) && x.date.isBefore(value.end))
        .toList();
    logger.log(
      '_filter() executed in ${stopwatch.elapsed} with ${metrics.length} items',
      name: "Metrics",
    );
    return result;
  }

  Future<RangeList> _getData(bool refresh) async {
    final loadedMetrics = await Dependencies.services.metric.metrics(
      widget.type.id,
      selectedDate.start,
      selectedDate.end,
      person: widget.person,
    );

    if(loadedMetrics.length <= 10){
      selection.selected.clear();
      selection.selected.addAll(loadedMetrics);
      withStats = false;
    } else {
      withStats = true;
    }

    final grouped = MetricHelper.group(
      loadedMetrics,
      selectedDate,
      500,
      widget.type,
    );
    metrics = loadedMetrics;
    filteredMetrics = grouped;
    maxY = grouped.maxY;

    return grouped;
  }

  void _resetMetric() {
    setState(() {
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  void _setDate(DateTimeRange value) {
    logger.log('set date with $value', name: "Metrics");
    setState(() {
      selectedDate = value;
      subDate = value;
    });
    _resetMetric();
  }

  void _setSubDate(DateTimeRange value) {
    logger.log('set subdate with $value', name: "Metrics");
    var filter = _filter(metrics, value);
    var grouped = MetricHelper.group(filter, value, 500, widget.type);
    setState(() {
      subDate = value;
      filteredMetrics = grouped;
    });
  }

  List<Widget> buildHeader() {
    return [
      DateRangePicker(
        _setDate,
        selectedDate,
        offset: widget.type.timeDifference,
        initial: widget.initialDate,
      ),
      NavigatorChart(
        selectedDate,
        subDate,
        _setSubDate,
        graph: WidgetGraph(
          metrics
              .map(
                (e) => Metric(
                  id: 0,
                  date: e.date,
                  value: e.value.toString(),
                  type: 0,
                  sourceId: '',
                  person: 0,
                ),
              )
              .toList(),
          selectedDate,
          widget.type,
          widget.settings,
          tile: metrics.length,
          width: 1,
          maxY: maxY,
        ),
      ),
    ];
  }

  Widget buildContent(BuildContext context, void Function() reset);
}
