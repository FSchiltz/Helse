import 'package:helse/logic/settings/ordered_item.dart';

class MetricsSettings {
  static const _metrics = "metrics";
  List<OrderedItem> metrics;

  MetricsSettings(this.metrics);

  // stupid boilerplate code because dart can't decode json
  MetricsSettings.fromJson(dynamic json)
      : metrics = (json[_metrics] as List<dynamic>? ?? [])
            .map((e) => OrderedItem.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        _metrics: metrics,
      };
}
