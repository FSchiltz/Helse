import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/ui/blocs/metrics/metric_file_list.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
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
  List<UIFile> _files = [];
  List<UIFile>? _oldFiles;

  @override
  void initState() {
    super.initState();
    final edit = widget.edit;
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
    final locale = Translation.of(context);
    return SquareDialog(
      title: Text(locale.addItem(widget.type.name)),
      icon: const Icon(Icons.add_chart_sharp),
      actions: [submitButton(locale.submit, _submit)],
      content: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: UIConstants.formPad,
              children: [
                ..._values.expand(
                  (e) => [
                    SquareTextField(
                      icon: Icons.add_sharp,
                      label: locale.value,
                      controller: e,
                      type: (widget.type.type == MetricDataType.number)
                          ? TextInputType.numberWithOptions(decimal: true)
                          : null,
                    ),
                  ],
                ),
                SquareTextField(
                  icon: Icons.design_services_outlined,
                  label: locale.tag,
                  controller: _tag,
                ),
                DateInput(
                  locale.date,
                  _date,
                  (value) => setState(() {
                    _date = value ?? DateTime.now();
                  }),
                ),
                MetricFileList(
                  metric: widget.edit?.id,
                  person: widget.person,
                  onChange: (x) {
                    _oldFiles ??= x.toList();
                    _files = x;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final value = MetricHelper().joinValue(_values.map((e) => e.text));

    int? metricId;
    if (widget.edit?.id != null) {
      final metric = UpdateMetric(
        id: widget.edit?.id ?? 0,
        date: _date.toUtc(),
        type: widget.type.id,
        tag: _tag.text,
        value: value,
        source: ImportTypes.none,
        sourceId: "",
      );

      await Dependencies.services.metric.updateMetric(metric);
      metricId = widget.edit?.id;
    } else {
      final metric = CreateMetric(
        date: _date.toUtc(),
        type: widget.type.id,
        tag: _tag.text,
        value: value,
        source: ImportTypes.none,
        sourceId: "",
      );

      metricId = await Dependencies.services.metric.addMetrics(
        metric,
        person: widget.person,
      );
    }

    if (metricId != null) {
      // find the files to add
      List<UIFile> fileToAdd = [];
      List<UIFile> fileToDelete = [];

      if (widget.edit == null) {
        fileToAdd = _files;
      } else {
        final newId = _files
            .where((e) => e.id != null)
            .map((e) => e.id)
            .toSet();

        final oldId = _oldFiles?.map((e) => e.id).toSet() ?? {};

        fileToAdd = _files
            .where(
              (e) =>
                  (e.id == null || e.id == 0 && e.file != null) ||
                  !oldId.contains(e.id),
            )
            .toList();

        fileToDelete =
            _oldFiles?.where((e) => !newId.contains(e.id)).toList() ?? [];
      }

      await Dependencies.logics.files.syncFiles(
        fileToAdd,
        fileToDelete.map((e) => e.id ?? 0),
        widget.person,
        (int fileId) => Dependencies.services.files.linkMetric(
          fileId,
          metricId!,
          widget.person,
        ),
        (int fileId) => Dependencies.services.files.unlinkMetric(
          fileId,
          metricId!,
          widget.person,
        ),
        (double progress, String status) => setState(() {
          progress = progress;
          stateInfo = status;
        }),
      );
    }

    widget.callback();
  }

  @override
  void dispose() {
    for (final controller in _values) {
      controller.dispose();
    }

    _tag.dispose();

    super.dispose();
  }
}
