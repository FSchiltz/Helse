import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/square_dialog.dart';
import 'package:helse/ui/common/square_text_field.dart';
import 'package:helse/ui/common/statefull_check.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/notification.dart';

class MetricGroupAdd extends StatefulWidget {
  final void Function()? callback;
  final MetricGroup? edit;

  const MetricGroupAdd(this.callback, {super.key, this.edit});

  @override
  State<MetricGroupAdd> createState() => _MetricGroupAddState();
}

class _MetricGroupAddState extends State<MetricGroupAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeDescription = FocusNode();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  bool _visible = true;
  bool _showDashboard = true;

  @override
  void initState() {
    super.initState();
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      controllerDescription.text = edit.description;
      controllerName.text = edit.name;
      _visible = edit.showTitle ?? false;
      _showDashboard = edit.showOnDashboard ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Add a new metric type"),
      actions: [
        SquareButton(widget.edit == null ? locale.create : locale.edit, submit),
      ],
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              Column(
                children: [
                  SquareTextField(
                    theme: theme,
                    icon: Icons.person_sharp,
                    controller: controllerName,
                    focusNode: focusNodeName,
                    label: locale.name,
                    validator: validateName,
                    onEditingComplete: () =>
                        focusNodeDescription.requestFocus(),
                  ),
                  const SizedBox(height: 10),
                  SquareTextField(
                    icon: Icons.person_sharp,
                    theme: theme,
                    controller: controllerDescription,
                    focusNode: focusNodeDescription,
                    label: locale.description,
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Show title"),
                        StatefullCheck(
                          _visible,
                          (bool value) => setState(() {
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
                        Text(locale.visible),
                        StatefullCheck(
                          _showDashboard,
                          (bool value) => setState(() {
                            _showDashboard = value;
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a name.";
    }

    return null;
  }

  void submit() async {
    var localContext = context;
    try {
      if (_formKey.currentState?.validate() ?? false) {
        var metric = MetricGroup(
          description: controllerDescription.text,
          name: controllerName.text,
          id: widget.edit?.id ?? 0,
          showTitle: _visible,
          showOnDashboard: _showDashboard,
        );
        String text;

        if (widget.edit == null) {
          text = "Added";
          await Dependencies.services.metric.addMetricsGroup(metric);
        } else {
          text = "Updated";
          await Dependencies.services.metric.updateMetricsGroup(metric);
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
}
