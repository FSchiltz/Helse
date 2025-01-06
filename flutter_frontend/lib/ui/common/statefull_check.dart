import 'package:flutter/material.dart';

class StatefullCheck extends StatefulWidget {
  const StatefullCheck(this.value, this.callback, {super.key});

  final bool value;
  final void Function(bool) callback;

  @override
  State<StatefullCheck> createState() => _StatefullCheckState();
}


class _StatefullCheckState extends State<StatefullCheck> {
  late bool check = widget.value;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: check,
        onChanged: (value) {
          setState(() {
            check = value ?? false;
          });

          widget.callback(value ?? false);
        });
  }
}
