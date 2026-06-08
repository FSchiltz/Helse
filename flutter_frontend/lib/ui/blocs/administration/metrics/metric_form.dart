import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/square_text_field.dart';

import '../../../common/statefull_check.dart';
import '../../../common/type_input.dart';

class MetricTypeAddForm extends StatelessWidget {
  final TextEditingController controllerName;
  final TextEditingController controllerDescription;
  final void Function(MetricSummary? value) summaryCallback;
  final void Function(MetricDataType? value) typeCallback;
  final MetricSummary? summary;
  final MetricDataType? type;
  final List<MetricGroup> groups;
  final List<Unit> units;

  final void Function(bool value) visibleCallback;
  final void Function(bool value) showCallback;
  final bool visible;
  final bool showDashboard;

  final FocusNode focusNodeName = FocusNode();
  final FocusNode focusNodeDescription = FocusNode();
  final FocusNode focusNodeUnit = FocusNode();

  final int group;
  final int unit;
  final void Function(int value) groupCallback;
  final void Function(int value) unitCallback;

  MetricTypeAddForm({
    super.key,
    required this.controllerName,
    required this.controllerDescription,
    required this.summaryCallback,
    required this.typeCallback,
    required this.summary,
    required this.type,
    required this.visible,
    required this.visibleCallback,
    required this.group,
    required this.groupCallback,
    required this.groups,
    required this.unit,
    required this.units,
    required this.unitCallback,
    required this.showDashboard,
    required this.showCallback,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    var locale = Translation.of(context);
    return Column(
      children: [
        SquareTextField(
          theme: theme,
          icon: Icons.person_sharp,
          controller: controllerName,
          focusNode: focusNodeName,
          label: locale.name,
          validator: validateName,
          onEditingComplete: () => focusNodeDescription.requestFocus(),
        ),
        const SizedBox(height: 10),
        SquareTextField(
          icon: Icons.person_sharp,
          theme: theme,
          controller: controllerDescription,
          focusNode: focusNodeDescription,
          label: locale.description,
          onEditingComplete: () => focusNodeUnit.requestFocus(),
        ),
        const SizedBox(height: 10),
        EnumInput(
          value: unit,
          units
              .map((x) => DropDownItem(x.id, x.description ?? x.code))
              .toList(),
          (value) => unitCallback.call(value ?? 0),
          label: locale.unit,
        ),
        const SizedBox(height: 10),
        EnumInput(
          value: type,
          MetricDataType.values.map((x) => DropDownItem(x, x.name)).toList(),
          (value) => typeCallback.call(value),
          label: 'Type',
        ),
        SizedBox(height: 10),
        EnumInput(
          value: group,
          groups.map((x) => DropDownItem(x.id, x.name)).toList(),
          (value) => groupCallback.call(value ?? 0),
          label: locale.group,
        ),
        const SizedBox(height: 10),
        EnumInput(
          value: summary,
          MetricSummary.values.map((x) => DropDownItem(x, x.name)).toList(),
          (value) => summaryCallback.call(value),
          label: locale.summary,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(locale.visible),
              StatefullCheck(visible, visibleCallback),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text("Show on dashboard: "),
              StatefullCheck(showDashboard, showCallback),
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
