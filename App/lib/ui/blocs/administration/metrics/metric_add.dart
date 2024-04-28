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
        // save the user
        String text;
        if (widget.edit == null) {
          var metric = MetricType(
            description: controllerDescription.text,
            name: controllerName.text,
            unit: controllerUnit.text,
            id: 0,
          );
          text = "Added";
          await AppState.metric?.addMetricsType(metric);
        } else {
          var metric = MetricType(
            description: controllerDescription.text,
            name: controllerName.text,
            unit: controllerUnit.text,
            id: widget.edit?.id,
          );
          text = "Updated";
          await AppState.metric?.updateMetricsType(metric);
        }
        _formKey.currentState?.reset();
        widget.callback?.call();

        if (localContext.mounted) {
          SuccessSnackBar.show("$text Successfully", localContext);

          Navigator.of(localContext).pop();
        }
      }
    } catch (ex) {
      if (localContext.mounted) {
        ErrorSnackBar.show("Error: $ex", localContext);
      }
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
