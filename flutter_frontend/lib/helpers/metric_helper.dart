import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';

class RangeList<T> {
  final List<MetricGrouped> values;
  final double min;
  final double max;

  RangeList({required this.values, required this.min, required this.max});
}

class MetricHelper {
  static String getMetricText(Metric metric) {
    String tag = '';

    if (metric.tag != null) tag += ': ${metric.tag}';
    if (metric.source != null && metric.source != FileTypes.none) {
      tag += '(${metric.source?.name})';
    }
    return tag;
  }

  static List<double> getValue(String value, MetricDataType? type) {
    var split = value.split(';');
    if (type == MetricDataType.bool) {
      return [bool.parse(value) ? 1 : 0];
    }

    return split.map((e) => double.parse(e)).toList();
  }

  static RangeList<MetricGrouped> group(
    List<Metric> metrics,
    DateTimeRange range,
    double bucketLength,
    MetricType type,
  ) {
    final stopwatch = Stopwatch()..start();
    log(
      'grouping with bucket lenght: $bucketLength for $range',
      name: "Metrics",
    );
    int graphCount = type.valueCount ?? 1;
    Map<int, MetricGrouped> groups = {};

    double max = 0;
    for (var metric in metrics) {
      final values = getValue(metric.value, type.type);

      final maxValue = values.max;
      if (maxValue > max) {
        max = maxValue;
      }

      // find the bucket
      final duration = metric.date.difference(range.start);
      final index = (duration.inMilliseconds / bucketLength).toInt();
      final bucket = groups[index];
      // if it does not exists create it
      if (bucket == null) {
        final start = range.start.add(
          Duration(milliseconds: (index * bucketLength).toInt()),
        );
        groups[index] = MetricGrouped(
          start.add(Duration(milliseconds: (bucketLength / 2).toInt())),
          values,
          [metric],
        );
      } else {
        for (int i = 0; i < graphCount; i++) {
          bucket.value[i] = (bucket.value[i] + values[i]) / 2;
        }
        bucket.metrics.add(metric);
      }
    }

    log('_group() executed in ${stopwatch.elapsed}', name: "Metrics");
    return RangeList(values: groups.values.toList(), min: 0, max: max);
  }

  String joinValue(Iterable<String> map) {
    return map.join(';');
  }

  static (String value, Icon? icon) getWidgetValue(
    List<Metric> metrics,
    MetricType type,
    BuildContext context,
  ) {
    var color = Dependencies.theme.stateColor(
      "${type.id}",
      StateType.metric,
      context,
    );

    Icon? icon;
    String value = '';
    switch (type.summaryType) {
      case MetricSummary.sum:
        icon = Icon(Icons.trending_up_sharp, color: color);
        value =
            '${metrics.map((metric) => double.parse(metric.value)).sum.round()}';
        break;
      case MetricSummary.mean:
        icon = Icon(Icons.update, color: color);
        value =
            '${(metrics.map((metric) => double.parse(metric.value)).sum / metrics.length).round()}';
        break;
      case MetricSummary.latest:
        value = metrics.last.value;

        break;
      default:
        value = metrics.last.value;
    }

    if (type.unit.code.isNotEmpty && value.isNotEmpty) {
      value += ' ${type.unit.code}';
    }

    return (value, icon);
  }

  static Widget getTextInfo(
    List<Metric> metrics,
    MetricType type,
    BuildContext context,
  ) {
    final (value, icon) = getWidgetValue(metrics, type, context);

    var text = Text(
      value,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.start,
    );

    if (icon == null) {
      return text;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon, SizedBox(width: 4), text],
    );
  }
}
