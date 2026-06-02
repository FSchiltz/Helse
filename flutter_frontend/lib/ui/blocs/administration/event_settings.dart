import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/events/event_settings.dart';
import 'package:helse/ui/blocs/administration/events/event_type.dart';

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
            Translation.locale(context).eventSettings,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          const EventSettingsView(),
          const SizedBox(height: 20),
          const EventTypeView(),
        ],
      ),
    );
  }
}
