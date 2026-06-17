import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/events/event_settings.dart';
import 'package:helse/ui/blocs/administration/events/event_type.dart';
import 'package:helse/ui/common/ui_constants.dart';

class EventSettings extends StatelessWidget {
  const EventSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translation.of(context).eventSettings,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: UIConstants.headerPad),
          const EventSettingsView(),
          const SizedBox(height: UIConstants.headerPad),
          const EventTypeView(),
        ],
      ),
    );
  }
}
