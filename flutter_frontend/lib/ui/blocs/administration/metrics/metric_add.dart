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

  final TextEditingController controllerUnit = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  MetricSummary? _metricSummary;
  MetricDataType? _type;
  bool _visible = true;
  bool _showDashboard = true;
  int _groupId = 0;

  List<MetricGroup> _groups = [];

  @override
  void initState() {
    super.initState();
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      controllerDescription.text = edit.description ?? "";
      controllerName.text = edit.name;
      controllerUnit.text = edit.unit ?? "";
      _visible = edit.visible ?? false;
      _showDashboard = edit.showOnDashboard ?? false;
      _groupId = edit.groupId ?? 0;
    }
    _loadGroup();
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
              MetricAddForm(
                controllerDescription: controllerDescription,
                controllerName: controllerName,
                controllerUnit: controllerUnit,
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
        var metric = MetricType(
          description: controllerDescription.text,
          name: controllerName.text,
          unit: controllerUnit.text,
          summaryType: _metricSummary,
          type: _type,
          id: widget.edit?.id ?? 0,
          visible: _visible,
          showOnDashboard: _showDashboard,
          groupId: _groupId,
          userEditable: true,
        );
        String text;

        if (widget.edit == null) {
          text = "Added";
          await Dependencies.services.metric.addMetricsType(metric);
        } else {
          text = "Updated";
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
    controllerUnit.dispose();
    super.dispose();
  }

  Future<void> _loadGroup() async {
    var result = (await Dependencies.services.metric.metricsGroup()) ?? [];
    result.add(MetricGroup(name: "Choose", description: '', id: 0));
    setState(() {
      _groups = result;
    });
  }
}
