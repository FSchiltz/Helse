import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/events_settings.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/logic/settings/settings_logic.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/ordered_list.dart';

class EventSettings extends StatefulWidget {
  const EventSettings({super.key});

  @override
  State<EventSettings> createState() => _EventSettingsState();
}

class _EventSettingsState extends State<EventSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  List<OrderedItem> _events = [];

  Future<int> _getData() async {
    _events = (await SettingsLogic.getEvents()).events;

    return 1;
  }

  void _submitEvent() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await DI.settings.saveEvents(EventsSettings(_events));

        Notify.show("Saved Successfully");
        _getData();
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (context, snapshot) {
        // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
            // if we got our data
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Events",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(width: 32),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: const ContinuousRectangleBorder(),
                            ),
                            onPressed: _submitEvent,
                            child: const Text("Save"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(child: OrderedList(_events)),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
      },
    );
  }
}
