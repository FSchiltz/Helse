import 'package:flutter/material.dart';

class HelseSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final void Function(bool value) onChanged;
  const HelseSwitch(this.label, this.value, this.onChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Text(label), CustomSwitch(value, onChanged)]);
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final void Function(bool value) onChanged;

  const CustomSwitch(this.value, this.onChanged, {super.key});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool value = false;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: value,
          onChanged: (bool? v) {
            setState(() {
              value = v ?? false;
            });
            widget.onChanged.call(value);
          },
        ),
      ),
    );
  }
}
