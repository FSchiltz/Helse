import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../notification.dart';
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

  @override
  Widget build(BuildContext context) {
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      controllerDescription.text = edit.description ?? "";
      controllerName.text = edit.name ?? "";
      controllerUnit.text = edit.unit ?? "";
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      scrollable: true,
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
          id: widget.edit?.id ?? 0,
        );
        String text;

        if (widget.edit == null) {
          text = "Added";
          await DI.metric?.addMetricsType(metric);
        } else {
          text = "Updated";
          await DI.metric?.updateMetricsType(metric);
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
}
