import 'package:flutter/material.dart';
import 'package:helse/ui/common/ui_constants.dart';

class EnabledInput extends StatelessWidget {
  const EnabledInput({
    super.key,
    required this.label,
    required this.enabled,
    required this.onChanged,
    required this.child,
  });

  final String label;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: UIConstants.formPad,
      children: [
        Checkbox(value: enabled, onChanged: (v) => onChanged(v ?? false)),
        Expanded(
          child: IgnorePointer(
            ignoring: !enabled,
            child: Opacity(opacity: enabled ? 1 : 0.5, child: child),
          ),
        ),
      ],
    );
  }
}
