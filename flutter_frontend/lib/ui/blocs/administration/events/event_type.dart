import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'event_add.dart';

class EventTypeView extends StatelessWidget {
  const EventTypeView({super.key});

  Future<List<EventType>> _getData(bool reset) async {
    return await DI.event.eventsType(true) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Event Types",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return EventTypeAdd(reset);
                      },
                    );
                  },
                  icon: const Icon(Icons.add_sharp),
                ),
              ],
            ),
            SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Expanded(child: Text("Id"))),
                  DataColumn(label: Expanded(child: Text("Name"))),
                  DataColumn(label: Expanded(child: Text("Description"))),
                  DataColumn(
                    label: Expanded(child: Text("Is standalone")),
                  ),
                  DataColumn(label: Expanded(child: Text("Visible"))),
                  DataColumn(label: Expanded(child: Text(""))),
                ],
                rows: data
                    .map(
                      (type) => DataRow(
                        cells: [
                          DataCell(Text((type.id).toString())),
                          DataCell(Text(type.name)),
                          DataCell(Text(type.description ?? "")),
                          DataCell(
                            Checkbox(
                              value: type.standAlone ?? true,
                              onChanged: null,
                            ),
                          ),
                          DataCell(
                            Checkbox(
                              value: type.visible ?? false,
                              onChanged: null,
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EventTypeAdd(
                                          reset,
                                          edit: type,
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit_sharp),
                                ),
                                if (type.userEditable == true)
                                  IconButton(
                                    onPressed: () async {
                                      await deleteType(type);
                                      reset();
                                    },
                                    icon: const Icon(Icons.delete_sharp),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteType(EventType type) async {
    var id = type.id;
    try {
      if (id != null) {
        await DI.event.deleteEventsType(id);
        Notify.show('Event ${type.name} deleted');
      }
    } catch (ex) {
      Notify.showError('Error deleting event ${type.name}');
    }
  }
}
