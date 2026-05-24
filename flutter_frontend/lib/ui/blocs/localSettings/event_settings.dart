import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/logic/settings/events_settings.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/statefull_check.dart';

class EventSettings extends StatefulWidget {
  const EventSettings({super.key});

  @override
  State<EventSettings> createState() => _EventSettingsState();
}

class _EventSettingsState extends State<EventSettings> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<List<OrderedItem>> _getData(bool refresh) async {
    return (await DI.settings.getEvents()).events;
  }

  void _submitEvent(List<OrderedItem> events) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await DI.settings.saveEvents(EventsSettings(events));

        Notify.show("Saved Successfully");
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        onPressed: () {
                          _submitEvent(data);
                          reset();
                        },
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: FittedBox(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Expanded(child: Text("Name"))),
                          DataColumn(label: Expanded(child: Text("Visible"))),
                        ],
                        rows: data
                            .map(
                              (item) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      item.name,
                                      style: theme.textTheme.titleLarge,
                                    ),
                                  ),
                                  DataCell(
                                    StatefullCheck(
                                      item.visible,
                                      (value) => item.visible = value,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
