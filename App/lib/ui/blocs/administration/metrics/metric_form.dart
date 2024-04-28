import 'package:flutter/material.dart';

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
        TextFormField(
          controller: widget.controllerName,
          keyboardType: TextInputType.name,
          focusNode: _focusNodeName,
          decoration: InputDecoration(
            labelText: "Name",
            prefixIcon: const Icon(Icons.person_sharp),
            prefixIconColor: theme.primary,
            filled: true,
            fillColor: theme.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primary),
            ),
          ),
          validator: validateName,
          onEditingComplete: () => _focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controllerDescription,
          keyboardType: TextInputType.name,
          focusNode: _focusNodeDescription,
          onEditingComplete: () => _focusNodeUnit.requestFocus(),
          decoration: InputDecoration(
            labelText: "Description",
            prefixIcon: const Icon(Icons.person_sharp),
            prefixIconColor: theme.primary,
            filled: true,
            fillColor: theme.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primary),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controllerUnit,
          focusNode: _focusNodeUnit,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Unit",
            prefixIcon: const Icon(Icons.email_sharp),
            prefixIconColor: theme.primary,
            filled: true,
            fillColor: theme.surface,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primary),
            ),
          ),
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

class UserNameInput extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final String? Function(String? value) validate;

  const UserNameInput({
    super.key,
    this.focus,
    this.controller,
    this.nextFocus,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      focusNode: focus,
      decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: const Icon(Icons.person_sharp),
        prefixIconColor: theme.primary,
        filled: true,
        fillColor: theme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primary),
        ),
      ),
      validator: validate,
      onEditingComplete: () => nextFocus?.requestFocus(),
    );
  }
}
