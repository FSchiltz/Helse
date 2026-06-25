import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/inputs/values_input.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/notification.dart';

class MetricTypeAdd extends StatefulWidget {
  final void Function()? callback;
  final MetricType? edit;

  const MetricTypeAdd(this.callback, {super.key, this.edit});

  @override
  State<MetricTypeAdd> createState() => _MetricTypeAddState();
}

class _MetricTypeAddState extends State<MetricTypeAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _focusName = FocusNode();
  final _focusDescription = FocusNode();
  final _focusUnit = FocusNode();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _valueCount = TextEditingController();
  final _timeDifference = TextEditingController();
  MetricSummary? _metricSummary;
  MetricDataType? _type;
  bool _visible = true;
  bool _showDashboard = true;
  int _groupId = 0;
  int _unit = 0;

  List<Group> _groups = [];
  List<Unit> _units = [];

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a name.";
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      _description.text = edit.description ?? "";
      _name.text = edit.name;
      _unit = edit.unit.id;
      _visible = edit.visible ?? true;
      _showDashboard = edit.showOnDashboard ?? true;
      _groupId = edit.groupId;
      _type = edit.type ?? MetricDataType.text;
      _metricSummary = edit.summaryType;
      _valueCount.text = (edit.valueCount ?? 0).toString();
      _timeDifference.text = (edit.timeDifference ?? '');
    }
    _loadGroup();
    _loadUnit();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Add a new metric type"),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SquareButton(
            widget.edit == null ? locale.create : locale.update,
            () => submit(locale),
          ),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [buildForm(context)]),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    var locale = Translation.of(context);
    return Column(
      children: [
        SquareTextField(
          icon: Icons.person_sharp,
          controller: _name,
          focusNode: _focusName,
          label: locale.name,
          validator: validateName,
          onEditingComplete: () => _focusDescription.requestFocus(),
        ),
        const SizedBox(height: UIConstants.formPad),
        SquareTextField(
          icon: Icons.person_sharp,
          controller: _description,
          focusNode: _focusDescription,
          label: locale.description,
          onEditingComplete: () => _focusUnit.requestFocus(),
        ),
        const SizedBox(height: UIConstants.formPad),
        ValuesInput(
          value: _unit,
          _units
              .map((x) => DropdownItem(x.id, x.description ?? x.code))
              .toList(),
          (value) => setState(() {
            _unit = value ?? 0;
          }),
          label: locale.unit,
        ),
        const SizedBox(height: UIConstants.formPad),
        ValuesInput(
          value: _type,
          MetricDataType.values.map((x) => DropdownItem(x, x.name)).toList(),
          (value) => setState(() {
            _type = value;
          }),
          label: 'Type',
        ),
        if (_type == MetricDataType.numberrange) SizedBox(height: 10),
        if (_type == MetricDataType.numberrange)
          SquareTextField(
            icon: Icons.numbers_sharp,
            controller: _valueCount,
            label: locale.value,
          ),
        SizedBox(height: UIConstants.formPad),
        ValuesInput(
          value: _groupId,
          _groups.map((x) => DropdownItem(x.id, x.name)).toList(),
          (value) => setState(() {
            _groupId = value ?? 0;
          }),
          label: locale.group,
        ),
        const SizedBox(height: UIConstants.formPad),
        ValuesInput(
          value: _metricSummary,
          MetricSummary.values.map((x) => DropdownItem(x, x.name)).toList(),
          (value) => setState(() {
            _metricSummary = value;
          }),
          label: locale.summary,
        ),
        const SizedBox(height: UIConstants.formPad),
        HelseSwitch(
          locale.visible,
          _visible,
          (value) => setState(() {
            _visible = value;
          }),
        ),
        const SizedBox(height: UIConstants.formPad),
        HelseSwitch(
          "Show on dashboard: ",
          _showDashboard,
          (value) => setState(() {
            _showDashboard = value;
          }),
        ),
        const SizedBox(height: UIConstants.formPad),
        Text(locale.timeShiftExplanation),
        SquareTextField(
          label: "Time difference",
          icon: Icons.timeline,
          controller: _timeDifference,
        ),
      ],
    );
  }

  void submit(AppLocalizations locale) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        final int? valueCount = (_valueCount.text.isNotEmpty)
            ? int.parse(_valueCount.text)
            : null;

        final timeDifference = _timeDifference.text.isEmpty
            ? null
            : _timeDifference.text;
        if (widget.edit == null) {
          var metric = CreateMetricType(
            description: _description.text,
            name: _name.text,
            unit: _unit,
            summaryType: _metricSummary,
            type: _type,
            visible: _visible,
            showOnDashboard: _showDashboard,
            groupId: _groupId,
            valueCount: valueCount,
            timeDifference: timeDifference,
          );
          await Dependencies.services.metric.addMetricsType(metric);
        } else {
          var metric = UpdateMetricType(
            description: _description.text,
            name: _name.text,
            unit: _unit,
            summaryType: _metricSummary,
            type: _type,
            id: widget.edit?.id ?? 0,
            visible: _visible,
            showOnDashboard: _showDashboard,
            groupId: _groupId,
            valueCount: valueCount,
            timeDifference: timeDifference,
          );
          await Dependencies.services.metric.updateMetricsType(metric);
        }

        _formKey.currentState?.reset();
        widget.callback?.call();

        if (mounted) {
          Notify.show(locale.saved, context);
          Navigator.of(context).pop();
        }
      }
    } catch (ex) {
      if (mounted) {
        Notify.showError(locale.error(ex.toString()), context);
      }
    }
  }

  @override
  void dispose() {
    _description.dispose();
    _name.dispose();
    _timeDifference.dispose();
    _valueCount.dispose();
    super.dispose();
  }

  Future<void> _loadGroup() async {
    var result = (await Dependencies.services.metric.metricsGroup()) ?? [];
    result.add(Group(name: "Choose", description: '', id: 0));
    setState(() {
      _groups = result;
    });
  }

  Future<void> _loadUnit() async {
    var result = await Dependencies.services.common.getUnits();
    setState(() {
      _units = result;
    });
  }
}
