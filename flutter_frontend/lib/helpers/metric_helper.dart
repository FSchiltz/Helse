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

  static Widget getTextInfo(
    List<Metric> metrics,
    MetricType type,
    BuildContext context,
  ) {
    var theme = Theme.of(context).textTheme;
    var color = Dependencies.theme.stateColor(
      "${type.id}",
      StateType.metric,
      context,
    );

    List<Widget> widgets = [];
    switch (type.summaryType) {
      case MetricSummary.sum:
        widgets.add(
          _getWidget(
            '${metrics.map((metric) => double.parse(metric.value)).sum.round()}',
            type,
            theme,
            icon: Icon(Icons.trending_up_sharp, color: color),
          ),
        );

        break;
      case MetricSummary.mean:
        if (metrics.length < 2) {
          widgets.add(_getWidget(metrics.first.value, type, theme));
        } else {
          double mean = 0;
          for (var metric in metrics) {
            mean += double.parse(metric.value);
          }

          widgets.add(
            _getWidget(
              (mean / metrics.length).toStringAsFixed(2),
              type,
              theme,
              icon: Icon(Icons.update, color: color),
            ),
          );
        }
        break;
      case MetricSummary.latest:
      default:
        widgets.add(_getWidget(metrics.last.value, type, theme));
    }

    return Wrap(spacing: 2, runSpacing: 2, children: widgets);
  }

  static Widget _getWidget(
    String value,
    MetricType type,
    TextTheme theme, {
    Icon? icon,
  }) {
    var text = Text(
      _getValue(value, type),
      style: theme.bodyMedium,
      textAlign: TextAlign.start,
    );

    if (icon == null) {
      return text;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [icon, SizedBox(width: 2), text],
    );
  }

  static String _getValue(String value, MetricType type) {
    switch (type.type) {
      case MetricDataType.text:
        return _withUnit(value, type.unit.code);
      case MetricDataType.number:
        var asDouble = double.parse(value);

        return _withUnit(
          (asDouble % 1 == 0)
              ? asDouble.toString()
              : asDouble.toStringAsFixed(2),
          type.unit.code,
        );
      case MetricDataType.bool:
        return value;
      case MetricDataType.numberrange:
        return value
            .split(';')
            .map((e) => _withUnit(e, type.unit.code))
            .join(' - ');
      default:
        return value;
    }
  }

  static String _withUnit(String value, String code) {
    if (code.isNotEmpty && value.isNotEmpty) {
      return '$value $code';
    }

    return value;
  }
}
