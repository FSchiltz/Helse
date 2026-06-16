import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/square_dialog.dart';
import 'package:helse/ui/common/square_text_field.dart';
import 'package:helse/ui/common/statefull_check.dart';
import 'package:helse/ui/common/type_input.dart';

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

  final focusNodeName = FocusNode();
  final focusNodeDescription = FocusNode();
  final focusNodeUnit = FocusNode();
  final controllerName = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerValueCount = TextEditingController();
  MetricSummary? _metricSummary;
  MetricDataType? _type;
  bool _visible = true;
  bool _showDashboard = true;
  int _groupId = 0;
  int _unit = 0;

  List<MetricGroup> _groups = [];
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
      controllerDescription.text = edit.description ?? "";
      controllerName.text = edit.name;
      _unit = edit.unit.id;
      _visible = edit.visible ?? true;
      _showDashboard = edit.showOnDashboard ?? true;
      _groupId = edit.groupId;
      _type = edit.type ?? MetricDataType.text;
      _metricSummary = edit.summaryType;
      controllerValueCount.text = (edit.valueCount ?? 0).toString();
    }
    _loadGroup();
    _loadUnit();
  }

  @override
  Widget build(BuildContext context) {
    return SquareDialog(
      title: const Text("Add a new metric type"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: const ContinuousRectangleBorder(),
          ),
          onPressed: submit,
          child: Text(widget.edit == null ? "Create" : "Update"),
        ),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(children: [buildForm(context)]),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var locale = Translation.of(context);
    return Column(
      children: [
        SquareTextField(
          theme: theme,
          icon: Icons.person_sharp,
          controller: controllerName,
          focusNode: focusNodeName,
          label: locale.name,
          validator: validateName,
          onEditingComplete: () => focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(
          icon: Icons.person_sharp,
          theme: theme,
          controller: controllerDescription,
          focusNode: focusNodeDescription,
          label: locale.description,
          onEditingComplete: () => focusNodeUnit.requestFocus(),
        ),
        const SizedBox(height: 10),
        EnumInput(
          value: _unit,
          _units
              .map((x) => DropDownItem(x.id, x.description ?? x.code))
              .toList(),
          (value) => setState(() {
            _unit = value ?? 0;
          }),
          label: locale.unit,
        ),
        const SizedBox(height: 10),
        EnumInput(
          value: _type,
          MetricDataType.values.map((x) => DropDownItem(x, x.name)).toList(),
          (value) => setState(() {
            _type = value;
          }),
          label: 'Type',
        ),
        if (_type == MetricDataType.numberrange) SizedBox(height: 10),
        if (_type == MetricDataType.numberrange)
          SquareTextField(
            icon: Icons.numbers_sharp,
            theme: theme,
            controller: controllerValueCount,
            label: locale.value,
          ),
        SizedBox(height: 10),
        EnumInput(
          value: _groupId,
          _groups.map((x) => DropDownItem(x.id, x.name)).toList(),
          (value) => setState(() {
            _groupId = value ?? 0;
          }),
          label: locale.group,
        ),
        const SizedBox(height: 10),
        EnumInput(
          value: _metricSummary,
          MetricSummary.values.map((x) => DropDownItem(x, x.name)).toList(),
          (value) => setState(() {
            _metricSummary = value;
          }),
          label: locale.summary,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(locale.visible),
              StatefullCheck(
                _visible,
                (value) => setState(() {
                  _visible = value;
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Show on dashboard: "),
              StatefullCheck(
                _showDashboard,
                (value) => setState(() {
                  _showDashboard = value;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void submit() async {
    var localContext = context;
    try {
      if (_formKey.currentState?.validate() ?? false) {
        String text;

        final int? valueCount = (controllerValueCount.text.isNotEmpty)
            ? int.parse(controllerValueCount.text)
            : null;
        if (widget.edit == null) {
          text = "Added";
          var metric = CreateMetricType(
            description: controllerDescription.text,
            name: controllerName.text,
            unit: _unit,
            summaryType: _metricSummary,
            type: _type,
            visible: _visible,
            showOnDashboard: _showDashboard,
            groupId: _groupId,
            userEditable: true,
            valueCount: valueCount,
          );
          await Dependencies.services.metric.addMetricsType(metric);
        } else {
          text = "Updated";
          var metric = UpdateMetricType(
            description: controllerDescription.text,
            name: controllerName.text,
            unit: _unit,
            summaryType: _metricSummary,
            type: _type,
            id: widget.edit?.id ?? 0,
            visible: _visible,
            showOnDashboard: _showDashboard,
            groupId: _groupId,
            userEditable: true,
            valueCount: valueCount,
          );
          await Dependencies.services.metric.updateMetricsType(metric);
        }

        _formKey.currentState?.reset();
        widget.callback?.call();

        if (localContext.mounted) {
          Navigator.of(localContext).pop();
        }
        Notify.show("$text Successfully");
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  void dispose() {
    controllerDescription.dispose();
    controllerName.dispose();
    super.dispose();
  }

  Future<void> _loadGroup() async {
    var result = (await Dependencies.services.metric.metricsGroup()) ?? [];
    result.add(MetricGroup(name: "Choose", description: '', id: 0));
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
