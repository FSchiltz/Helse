import 'package:flutter/material.dart' hide Interval;
import 'package:helse/di/dependencies.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/key_value_list.dart';

class MetricInformation extends StatelessWidget {
  const MetricInformation(this.stats, {super.key, required this.type});

  final List<KeyValue> stats;
  final MetricType type;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var color = Dependencies.theme.stateColor(
      type.id.toString(),
      StateType.metric,
      context,
    );
    return Wrap(
      runSpacing: 1,
      spacing: 8,
      children: stats
          .map(
            (e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(e.icon, color: color),
                SizedBox(width: 4),
                Text(
                  e.value ?? '',
                  style: theme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
