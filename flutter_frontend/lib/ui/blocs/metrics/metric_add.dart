import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/helpers/metric_helper.dart';
import 'package:helse/helpers/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../di/dependencies.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/inputs/date_input.dart';
import '../../common/layout/square_dialog.dart';
import '../../common/inputs/square_text_field.dart';

class MetricAdd extends StatefulWidget {
  final MetricType type;
  final void Function() callback;
  final int? person;
  final Metric? edit;

  const MetricAdd(
    this.type,
    this.callback, {
    super.key,
    this.person,
    this.edit,
  });

  @override
  State<MetricAdd> createState() => _MetricAddState();
}

class _MetricAddState extends PopupSubmitState<MetricAdd> {
  DateTime _date = DateTime.now();
  List<TextEditingController> _values = [];
  final TextEditingController _tag = TextEditingController();

  @override
  void initState() {
    super.initState();

    var edit = widget.edit;
    if (edit != null) {
      _date = edit.date.toLocal();
      final values = MetricHelper.getValue(edit.value, widget.type.type);

      _values = values
          .map((e) => TextEditingController(text: e.toString()))
          .toList();
      _tag.text = edit.tag ?? '';
    } else {
      _values = List<TextEditingController>.generate(
        max(widget.type.valueCount ?? 1, 1),
        (e) => TextEditingController(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.addItem(widget.type.name)),
      icon: const Icon(Icons.add_chart_sharp),
      actions: [submitButton(locale.submit, _submit)],
      content: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ..._values.expand(
                  (e) => [
                    SquareTextField(
                      icon: Icons.add_sharp,
                      label: locale.value,
                      controller: e,
                    ),
                    const SizedBox(height: UIConstants.formPad),
                  ],
                ),
                SquareTextField(
                  icon: Icons.design_services_outlined,
                  label: locale.tag,
                  controller: _tag,
                ),
                const SizedBox(height: UIConstants.formPad),
                DateInput(
                  locale.date,
                  _date,
                  (value) => setState(() {
                    _date = value ?? DateTime.now();
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (widget.edit?.id != null) {
      var metric = UpdateMetric(
        id: widget.edit?.id ?? 0,
        date: _date.toUtc(),
        type: widget.type.id,
        tag: _tag.text,
        value: MetricHelper().joinValue(_values.map((e) => e.text)),
        source: FileTypes.none,
        sourceId: "",
      );
      await Dependencies.services.metric.updateMetrics(metric);
    } else {
      var metric = CreateMetric(
        date: _date.toUtc(),
        type: widget.type.id,
        tag: _tag.text,
        value: MetricHelper().joinValue(_values.map((e) => e.text)),
        source: FileTypes.none,
        sourceId: "",
      );
      await Dependencies.services.metric.addMetrics(
        metric,
        person: widget.person,
      );
    }

    widget.callback();
  }
}
