import 'package:material_ui/material_ui.dart';

class TimelineFiller extends StatelessWidget {
  const TimelineFiller(this.width, {super.key});

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
