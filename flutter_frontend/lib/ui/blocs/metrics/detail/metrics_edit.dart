import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/inputs/enabled_input.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/date_input.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/ui_constants.dart';

class MetricsEdit extends StatefulWidget {
  final MetricType type;
  final void Function() callback;
  final int? person;
  final List<Metric> edit;
  const MetricsEdit(
    this.type,
    this.callback, {
    super.key,
    this.person,
    required this.edit,
  });

  @override
  State<MetricsEdit> createState() => _MetricsEditState();
}

class _MetricsEditState extends PopupSubmitState<MetricsEdit> {
  DateTime _date = DateTime.now();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _tag = TextEditingController();
  bool _updateValue = false;
  bool _updateTag = false;
  bool _updateDate = false;

  Future<void> _submit() async {
    final patch = PatchMetric(
      type: widget.type.id,
      date: _date,
      updateDate: _updateDate,
      value: _value.text,
      updateValue: _updateValue,
      tag: _tag.text,
      updateTag: _updateTag,
      source: FileTypes.none,
      sourceId: "",
      ids: widget.edit.map((e) => e.id).toList(),
    );

    await Dependencies.services.metric.updateMetrics(
      patch,
      person: widget.person,
    );
    widget.callback.call();
  }

  @override
  void dispose() {
    _value.dispose();
    _tag.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Translation.of(context);
    return SquareDialog(
      icon: const Icon(Icons.edit_note),
      title: Text(
        locale.bulkMetric(widget.edit.length),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [submitButton(locale.submit, _submit)],
      content: SingleChildScrollView(
        child: Column(
          spacing: UIConstants.formPad,
          children: [
            EnabledInput(
              label: locale.description,
              enabled: _updateValue,
              onChanged: (v) => setState(() => _updateValue = v),
              child: SquareTextField(
                icon: Icons.numbers_sharp,
                label: locale.value,
                controller: _value,
              ),
            ),

            EnabledInput(
              label: locale.tag,
              enabled: _updateTag,
              onChanged: (v) => setState(() => _updateTag = v),
              child: SquareTextField(
                icon: Icons.tag_sharp,
                label: locale.tag,
                controller: _tag,
              ),
            ),
            EnabledInput(
              label: locale.start,
              enabled: _updateDate,
              onChanged: (v) => setState(() => _updateDate = v),
              child: DateInput(
                locale.date,
                _date,
                (date) => setState(() {
                  _date = date ?? DateTime.now();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
