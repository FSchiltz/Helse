import 'dart:developer';
import 'dart:math' show max;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/range_list.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/delete_metric.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_more_info.dart';
import 'package:helse/ui/blocs/metrics/metric_add.dart';
import 'package:helse/ui/blocs/metrics/metric_grouped.dart';

class MetricHelper {
  static String getMetricText(Metric metric) {
    String tag = '';

    if (metric.tag != null) tag += ': ${metric.tag}';
    if (metric.source != null && metric.source != ImportTypes.none) {
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

  static RangeList group(
    List<Metric> metrics,
    DateTimeRange range,
    int tile,
    MetricType type,
  ) {
    final stopwatch = Stopwatch()..start();

    final bucketLength = range.duration.inMilliseconds / tile;
    final skipGroup = metrics.length <= tile * 2;
    log(
      'grouping with bucket lenght: $bucketLength for $range',
      name: "Metrics",
    );
    int graphCount = max(1, type.valueCount ?? 1);
    Map<int, MetricGrouped> groups = {};

    int i = 0;
    double maxY = 0;
    List<double> maximum = List<double>.filled(graphCount, 0);
    List<double> minimum = List<double>.filled(graphCount, double.maxFinite);
    List<double> mean = List<double>.filled(graphCount, 0);
    final List<List<(int, double)>> allValues =
        List<List<(int, double)>>.generate(graphCount, (index) => []);

    for (var metric in metrics) {
      final values = getValue(metric.value, type.type);
      for (var j = 0; j < graphCount; j++) {
        allValues[j].add((metric.id, values[j]));
      }

      for (int j = 0; j < graphCount; j++) {
        final value = values[j];
        // add the value to the correct stats

        mean[j] = mean[j] + value;

        if (value > maximum[j]) {
          maximum[j] = value;
        }

        if (value < minimum[j]) {
          minimum[j] = value;
        }

        // find the max value possible to set the Y axis of the graph
        if (value > maxY) {
          maxY = value;
        }
      }

      // find the bucket
      if (skipGroup) {
        groups[i] = MetricGrouped(metric.date, values, [metric]);
      } else {
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

      i++;
    }

    List<RawStats> stats = [];
    for (var i = 0; i < graphCount; i++) {
      stats.add(
        RawStats(
          allValues[i],
          min: minimum[i],
          max: maximum[i],
          mean: mean[i] / metrics.length,
        ),
      );
    }

    log('_group() executed in ${stopwatch.elapsed}', name: "Metrics");
    return RangeList(values: groups.values.toList(), maxY: maxY, stats: stats);
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
      getStateKey(type, 0),
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

  static String getStateKey(MetricType type, int i) {
    if ((type.valueCount ?? 0) > 0) {
      return '${type.id};$i';
    }

    return type.id.toString();
  }

  static List<Widget> getButtons(
    Metric metric,
    MetricType type,
    void Function() reset, {
    required BuildContext context,
    int? person,
    bool open = true,
  }) {
    return [
      if (open)
        IconButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return MetricMoreInfo(
                  type,
                  reset,
                  person: person,
                  metric: metric,
                );
              },
            );
          },
          icon: const Icon(Icons.open_in_new_sharp),
        ),
      IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return MetricAdd(type, reset, person: person, edit: metric);
            },
          );
        },
        icon: const Icon(Icons.edit_sharp),
      ),
      IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return DeleteMetric(() async {
                await Dependencies.services.metric.deleteMetric(metric.id);
                reset();
              }, person: person);
            },
          );
        },
        icon: const Icon(Icons.delete_sharp),
      ),
    ];
  }

  static TextStats groupText(List<Metric> metrics) {
    Map<String, List<Metric>> values = {};

    double totalMilliseconds = 0;

    for (var i = 0; i < metrics.length; i++) {
      final current = metrics[i];

      if (i < metrics.length - 1) {
        totalMilliseconds += metrics[i + 1].date
            .difference(current.date)
            .inMilliseconds;
      }

      final key = current.value.trim().toLowerCase();
      final existing = values[key] ?? [];
      existing.add(current);
      values[key] = existing;
    }

    List<HistogramBar> indexedValues = [];
    var ordered = values.entries.sorted(
      (b, a) => a.value.length.compareTo(b.value.length),
    );

    indexedValues = ordered
        .take(5)
        .map((e) => HistogramBar(e.value, e.key))
        .toList();

    if (values.length > 6) {
      final rest = ordered
          .skip(5)
          .fold(<Metric>[], (p, e) => p..addAll(e.value))
          .toList();

      indexedValues.add(HistogramBar(rest, "Other"));
    } else if (values.length == 5) {
      final last = ordered[5];
      indexedValues.add(HistogramBar(last.value, last.key));
    }

    final mean = Duration(
      milliseconds: totalMilliseconds ~/ (metrics.length - 1),
    );

    return TextStats(metrics.length, mean, indexedValues);
  }
}
