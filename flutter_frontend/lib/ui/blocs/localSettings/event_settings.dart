import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/localSettings/ordered_edit_item.dart';
import 'package:helse/ui/common/inputs/statefull_check.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/ui_constants.dart';

class EventsSettings extends StatefulWidget {
  final bool isPatient;
  final int? patient;
  const EventsSettings({super.key, this.isPatient = false, this.patient});

  @override
  State<EventsSettings> createState() => _EventsSettingsState();
}

class _EventsSettingsState extends State<EventsSettings> {
  Future<List<OrderedEditItem>> _getData(bool refresh) async {
    EventSettings items;
    if (widget.isPatient) {
      items = Dependencies.logics.patientsSettings.getEvents(widget.patient);
    } else {
      items = Dependencies.logics.settings.getEvents();
    }

    return items.displaySettings
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
        var settings = Dependencies.logics.patientsSettings.getEvents(
          widget.patient,
        );
        await Dependencies.logics.patientsSettings.saveEvents(
          settings.copyWith(displaySettings: toSave),
          true,
          widget.patient,
        );
      } else {
        var settings = Dependencies.logics.settings.getEvents();
        await Dependencies.logics.settings.saveEvents(
          settings.copyWith(displaySettings: toSave),
          true,
        );
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
        var locale = Translation.of(context);
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
                    child: SquareButton(locale.save, () async {
                      await _submitEvent(data, locale);
                      reset();
                    }),
                  ),
                ],
              ),
              const SizedBox(height: UIConstants.headerPad),
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
