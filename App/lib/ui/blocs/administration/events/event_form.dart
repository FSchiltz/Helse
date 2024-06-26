import 'package:flutter/material.dart';

import '../../../common/square_text_field.dart';
import '../../../common/statefull_check.dart';

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
    var theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SquareTextField(
          controller: controllerName,
          focusNode: focusNodeName,
          label: "name",
          icon: Icons.person_sharp,
          theme: theme,
          validator: validateName,
          onEditingComplete: () => focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(
          controller: controllerDescription,
          focusNode: focusNodeDescription,
          label: "Description",
          icon: Icons.person_sharp,
          theme: theme,
        ),Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            const Text("Visible: "),
            StatefullCheck(visible, visibleCallback),
          ]),
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
