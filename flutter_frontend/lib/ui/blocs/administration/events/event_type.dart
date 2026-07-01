import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'event_type_add.dart';

class EventTypeView extends StatelessWidget {
  const EventTypeView({super.key});

  Future<List<EventType>> _getData(bool reset) async {
    return await Dependencies.services.event.eventsType(true) ?? [];
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
                const SizedBox(width: UIConstants.formPad),
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
              child: FittedBox(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Expanded(child: Text("Id"))),
                    DataColumn(label: Expanded(child: Text("Name"))),
                    DataColumn(label: Expanded(child: Text("Description"))),
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
                              Checkbox(value: type.visible, onChanged: null),
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
                                        await deleteType(type, context);
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
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteType(EventType type, BuildContext context) async {
    final locale = Translation.of(context);
    var id = type.id;
    try {
      await Dependencies.services.event.deleteEventsType(id);

      Notify.showIcon(NotificationKind.success);
    } catch (ex) {
      Notify.show(
        locale.error(ex.toString()),
        context: context.mounted ? context : null,
        kind: NotificationKind.error,
      );
    }
  }
}
