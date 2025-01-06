import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final void Function(bool? value) onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

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
            widget.onChanged.call(v);
          },
        ),
      ),
    );
  }
}
