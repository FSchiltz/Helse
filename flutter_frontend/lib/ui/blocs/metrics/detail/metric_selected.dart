import 'package:flutter/material.dart';
import 'package:helse/helpers/selection_controller.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_data_table.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class MetricSelected extends StatefulWidget {
  const MetricSelected({
    super.key,
    required this.selection,
    required this.type,
    required this.reset,
  });

  final MetricType type;
  final SelectionController<Metric> selection;
  final void Function() reset;

  @override
  State<MetricSelected> createState() => _MetricSelectedState();
}

class _MetricSelectedState extends State<MetricSelected> {
  bool state = false;
  @override
  void initState() {
    super.initState();
    widget.selection.addListener(
      () => setState(() {
        state = !state;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: (widget.selection.selected.isEmpty)
          ? SizedBox.shrink()
          : MetricDataTable(
              count: widget.selection.selected.length,
              type: widget.type,
              reset: widget.reset,
              state: state,
              callback: (page, count) async {
                return widget.selection.selected
                    .skip(page * count)
                    .take(count)
                    .toList();
              },
            ),
    );
  }
}
