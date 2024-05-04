import 'package:flutter/material.dart';

import '../../../helpers/square_outline_input_border.dart';
import '../../../helpers/square_text_field.dart';

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
        SquareTextField(
          controller: widget.controllerName,
          focusNode: _focusNodeName,
          label: "name",
          icon: Icons.person_sharp,
          theme: theme,
          validator: validateName,
          onEditingComplete: () => _focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(
          controller: widget.controllerDescription,
          focusNode: _focusNodeDescription,
          label: "Description",
          icon: Icons.person_sharp,
          theme: theme,
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
