import 'package:flutter/material.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/metric_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/key_value_list.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';

class MetricMoreInfo extends StatelessWidget {
  final Metric metric;
  final MetricType type;
  final void Function() reset;
  final int? person;

  const MetricMoreInfo(
    this.type,
    this.reset, {
    super.key,
    required this.metric,
    this.person,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    final Unit unit = (metric.unit ?? type.unit) as Unit;
    return SquareDialog(
      actions: MetricHelper.getButtons(
        metric,
        type,
        reset,
        context: context,
        open: false,
      ),
      icon: const Icon(Icons.open_in_new_sharp),
      title: Text(
        locale.detailof(metric.id.toString()),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: KeyValueList([
        KeyValue(locale.id, value: metric.id.toString()),
        KeyValue(locale.value, value: metric.value),
        KeyValue(
          locale.unit,
          value: '',
          children: [
            KeyValue('Description', value: unit.description),
            KeyValue('Unit', value: unit.code),
          ],
        ),
        KeyValue(
          locale.date,
          value: DateHelper.format(metric.date, context: context),
        ),
        KeyValue(locale.tag, value: metric.tag),
        KeyValue(locale.source, value: metric.source?.name),
        KeyValue("Source id", value: metric.sourceId),
      ]),
    );
  }
}
