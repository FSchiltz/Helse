import 'package:flutter/material.dart';

class TimelineFiller extends StatelessWidget {
  const TimelineFiller(this.width, {super.key});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
