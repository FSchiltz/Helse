import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/square_dialog.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/notification.dart';
import 'metric_form.dart';

class MetricTypeAdd extends StatefulWidget {
  final void Function()? callback;
  final MetricType? edit;

  const MetricTypeAdd(this.callback, {super.key, this.edit});

  @override
  State<MetricTypeAdd> createState() => _MetricTypeAddState();
}

class _MetricTypeAddState extends State<MetricTypeAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  MetricSummary? _metricSummary;
  MetricDataType? _type;
  bool _visible = true;
  bool _showDashboard = true;
  int _groupId = 0;
  int _unit = 0;

  List<MetricGroup> _groups = [];
  List<Unit> _units = [];

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
          child: Column(
            children: [
              MetricTypeAddForm(
                controllerDescription: controllerDescription,
                controllerName: controllerName,
                type: _type,
                summary: _metricSummary,
                summaryCallback: (MetricSummary? value) => setState(() {
                  _metricSummary = value;
                }),
                typeCallback: (MetricDataType? value) => setState(() {
                  _type = value;
                }),
                visible: _visible,
                visibleCallback: (bool value) => setState(() {
                  _visible = value;
                }),
                group: _groupId,
                groupCallback: (int value) => setState(() {
                  _groupId = value;
                }),
                groups: _groups,
                showDashboard: _showDashboard,
                showCallback: (bool value) => setState(() {
                  _showDashboard = value;
                }),
                unit: _unit,
                unitCallback: (int value) => setState(() {
                  _unit = value;
                }),
                units: _units,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {
    var localContext = context;
    try {
      if (_formKey.currentState?.validate() ?? false) {
        String text;

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
