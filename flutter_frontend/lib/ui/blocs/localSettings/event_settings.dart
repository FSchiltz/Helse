import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/localSettings/ordered_edit_item.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/statefull_check.dart';

class EventSettings extends StatefulWidget {
  final bool isPatient;
  const EventSettings({super.key, this.isPatient = false});

  @override
  State<EventSettings> createState() => _EventSettingsState();
}

class _EventSettingsState extends State<EventSettings> {
  Future<List<OrderedEditItem>> _getData(bool refresh) async {
    List<OrderedItem> items;
    if (widget.isPatient) {
      items = await Dependencies.logics.patientsSettings.getEvents();
    } else {
      items = await Dependencies.logics.settings.getEvents();
    }

    return items
        .map(
          (e) => OrderedEditItem(
            visible: e.visible ?? true,
            name: e.name,
            id: e.id,
            detailGraph: e.detailGraph,
            graph: e.graph,
            order: e.order,
            showOnDashboard: e.showOnDashboard ?? true,
          ),
        )
        .toList();
  }

  Future<void> _submitEvent(
    List<OrderedEditItem> events,
    AppLocalizations locale,
  ) async {
    try {
      var toSave = events.map((e) => e.ordered()).toList();
      // save the user's settings
      if (widget.isPatient) {
        await Dependencies.logics.patientsSettings.saveEvents(toSave, true);
      } else {
        await Dependencies.logics.settings.saveEvents(toSave, true);
      }

      Notify.show(locale.saved);
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        var locale = Translation.locale(context);
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    locale.events,
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
                      onPressed: () async {
                        await _submitEvent(data, locale);
                        reset();
                      },
                      child: Text(locale.save),
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
                        DataColumn(label: Expanded(child: Text(locale.name))),
                        DataColumn(
                          label: Expanded(child: Text(locale.visible)),
                        ),
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
        );
      },
    );
  }
}
