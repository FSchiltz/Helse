import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/popup_submit_state.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/inputs/square_text_field.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';

class MetricGroupAdd extends StatefulWidget {
  final void Function()? callback;
  final Group? edit;

  const MetricGroupAdd(this.callback, {super.key, this.edit});

  @override
  State<MetricGroupAdd> createState() => _MetricGroupAddState();
}

class _MetricGroupAddState extends PopupSubmitState<MetricGroupAdd> {
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  bool _visible = true;
  bool _showDashboard = true;

  @override
  void initState() {
    super.initState();
    var edit = widget.edit;
    if (edit != null) {
      // this is not a new addition, just an edit
      _controllerDescription.text = edit.description;
      _controllerName.text = edit.name;
      _visible = edit.showTitle ?? false;
      _showDashboard = edit.showOnDashboard ?? false;
    }
  }

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return SquareDialog(
      title: const Text("Add a new metric type"),
      actions: [
        submitButton(widget.edit == null ? locale.create : locale.edit, _submit),
      ],
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SquareTextField(
                    icon: Icons.person_sharp,
                    controller: _controllerName,
                    focusNode: _focusNodeName,
                    label: locale.name,
                    validator: validateName,
                    onEditingComplete: () =>
                        _focusNodeDescription.requestFocus(),
                  ),
                  const SizedBox(height: UIConstants.formPad),
                  SquareTextField(
                    icon: Icons.person_sharp,
                    controller: _controllerDescription,
                    focusNode: _focusNodeDescription,
                    label: locale.description,
                  ),

                  const SizedBox(height: UIConstants.formPad),
                  HelseSwitch(
                    "Show title",
                    _visible,
                    (bool value) => setState(() {
                      _visible = value;
                    }),
                  ),

                  const SizedBox(height: UIConstants.formPad),
                  HelseSwitch(
                    locale.visible,
                    _showDashboard,
                    (bool value) => setState(() {
                      _showDashboard = value;
                    }),
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

  Future<void> _submit() async {
    if (widget.edit == null) {
      final metric = CreateGroup(
        description: _controllerDescription.text,
        name: _controllerName.text,
        showTitle: _visible,
        showOnDashboard: _showDashboard,
      );
      await Dependencies.services.metric.addGroup(metric);
    } else {
      final metric = UpdateGroup(
        description: _controllerDescription.text,
        name: _controllerName.text,
        id: widget.edit?.id ?? 0,
        showTitle: _visible,
        showOnDashboard: _showDashboard,
      );
      await Dependencies.services.metric.updateGroup(metric);
    }

    widget.callback?.call();
  }
}
