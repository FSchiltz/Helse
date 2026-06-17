import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final IconData? icon;
  const SquareButton(this.label, this.onPressed, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: const ContinuousRectangleBorder(),
      ),
      onPressed: onPressed,
      child: icon == null
          ? Text(label, style: Theme.of(context).textTheme.titleMedium)
          : Row(
              children: [
                Icon(icon),
                SizedBox(width: 12),
                Text(label, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
    );
  }
}
