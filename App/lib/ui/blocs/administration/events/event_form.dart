import 'package:flutter/material.dart';

class EventAddForm extends StatefulWidget {
  final TextEditingController controllerDescription;
  final TextEditingController controllerName;

  const EventAddForm({
    super.key,
    required this.controllerDescription,
    required this.controllerName,
  });

  @override
  State<EventAddForm> createState() => _EventAddFormState();
}

class _EventAddFormState extends State<EventAddForm> {
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();

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
    super.dispose();
  }
}
