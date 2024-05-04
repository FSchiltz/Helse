import 'package:flutter/material.dart';
import 'package:helse/ui/helpers/square_text_field.dart';


class MetricAddForm extends StatefulWidget {
  final TextEditingController controllerUnit;
  final TextEditingController controllerName;
  final TextEditingController controllerDescription;

  const MetricAddForm({
    super.key,
    required this.controllerUnit,
    required this.controllerName,
    required this.controllerDescription,
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
        SquareTextField(
            controller: widget.controllerUnit,
            icon: Icons.email_sharp,
            focusNode: _focusNodeUnit,
            theme: theme,
            label: "Unit"),
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
