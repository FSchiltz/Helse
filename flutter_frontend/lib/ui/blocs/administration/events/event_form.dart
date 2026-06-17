import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';

import '../../../common/inputs/square_text_field.dart';
import '../../../common/inputs/statefull_check.dart';

class EventAddForm extends StatelessWidget {
  final TextEditingController controllerDescription;
  final TextEditingController controllerName;
  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeDescription = FocusNode();

  final void Function(bool value) visibleCallback;
  final bool visible;

  EventAddForm({
    super.key,
    required this.controllerDescription,
    required this.controllerName,
    required this.visible,
    required this.visibleCallback,
  });

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return Column(
      children: [
        SquareTextField(
          controller: controllerName,
          focusNode: focusNodeName,
          label: locale.name,
          icon: Icons.person_sharp,
          validator: validateName,
          onEditingComplete: () => focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(
          controller: controllerDescription,
          focusNode: focusNodeDescription,
          label: locale.description,
          icon: Icons.person_sharp,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Visible: "),
              StatefullCheck(visible, visibleCallback),
            ],
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
}
