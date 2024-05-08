import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/swagger.swagger.dart';
import 'package:helse/ui/theme/square_text_field.dart';

import '../../../theme/type_input.dart';

class MetricAddForm extends StatefulWidget {
  final TextEditingController controllerUnit;
  final TextEditingController controllerName;
  final TextEditingController controllerDescription;
  final void Function(MetricSummary? value) summaryCallback;
  final void Function(MetricDataType? value) typeCallback;

  const MetricAddForm({
    super.key,
    required this.controllerUnit,
    required this.controllerName,
    required this.controllerDescription,
    required this.summaryCallback,
    required this.typeCallback,
  });

  @override
  State<MetricAddForm> createState() => _MetricAddFormState();
}

class _MetricAddFormState extends State<MetricAddForm> {
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();
  final FocusNode _focusNodeUnit = FocusNode();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SquareTextField(
          theme: theme,
          icon: Icons.person_sharp,
          controller: widget.controllerName,
          focusNode: _focusNodeName,
          label: "Name",
          validator: validateName,
          onEditingComplete: () => _focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(
          icon: Icons.person_sharp,
          theme: theme,
          controller: widget.controllerDescription,
          focusNode: _focusNodeDescription,
          label: "Description",
          onEditingComplete: () => _focusNodeUnit.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(controller: widget.controllerUnit, icon: Icons.email_sharp, focusNode: _focusNodeUnit, theme: theme, label: "Unit"),
        const SizedBox(height: 10),
        TypeInput(
          MetricDataType.values,
          (value) => widget.typeCallback.call(value),
          label: 'Type',
        ),
        const SizedBox(height: 10),
        TypeInput(
          MetricSummary.values,
          (value) => widget.summaryCallback.call(value),
          label: 'Summary',
        ),
      ],
    );
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a name.";
    }

    return null;
  }

  @override
  void dispose() {
    _focusNodeDescription.dispose();
    _focusNodeName.dispose();
    _focusNodeUnit.dispose();
    super.dispose();
  }
}
