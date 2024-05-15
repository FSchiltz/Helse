import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../../common/loader.dart';
import 'event_add.dart';

class EventTypeView extends StatefulWidget {
  const EventTypeView({super.key});

  @override
  State<EventTypeView> createState() => _EventTypeViewState();
}

class _EventTypeViewState extends State<EventTypeView> {
  List<EventType>? _types;

  void _resetEventType() {
    setState(() {
      _types = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<List<EventType>?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_types != null) return _types;

    _types = await DI.event?.eventsType(true);
    return _types;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(_dummy),
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
              // Extracting data from snapshot object
              final types = snapshot.data as List<EventType>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text("Event Types", style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return EventTypeAdd(_resetEventType);
                                });
                          },
                          icon: const Icon(Icons.add_sharp)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(
                                label: Expanded(
                              child: Text("Id"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Name"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Description"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Is standalone"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Visible"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text(""),
                            ))
                          ],
                          rows: types
                              .map((type) => DataRow(cells: [
                                    DataCell(Text((type.id).toString())),
                                    DataCell(Text(type.name ?? "")),
                                    DataCell(Text(type.description ?? "")),
                                    DataCell(Checkbox(value: type.standAlone ?? true, onChanged: null)),
                                    DataCell(Checkbox(value: type.visible ?? false, onChanged: null)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                showDialog<void>(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return EventTypeAdd(_resetEventType, edit: type);
                                                    });
                                              },
                                              icon: const Icon(Icons.edit_sharp)),
                                          if (type.userEditable == true)
                                            IconButton(
                                              onPressed: () async => deleteType(type),
                                              icon: const Icon(Icons.delete_sharp),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ]))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }

  Future<void> deleteType(EventType type) async {
    var id = type.id;
    try {
      if (id != null) {
        await DI.event?.deleteEventsType(id);
        Notify.show('Event ${type.name} deleted');
        _resetEventType();
      }
    } catch (ex) {
      Notify.showError('Error deleting event ${type.name}');
    }
  }
}
