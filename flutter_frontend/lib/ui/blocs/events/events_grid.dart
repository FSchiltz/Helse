import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/theme_helper.dart';
import 'package:helse/ui/common/loader.dart';

import '../../../di/dependencies.dart';
import '../../../logic/settings/settings_logic.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/notification.dart';
import 'events_widget.dart';

class EventsGrid extends StatefulWidget {
  const EventsGrid({super.key, required this.date, this.person});

  final DateTimeRange date;
  final int? person;

  @override
  State<EventsGrid> createState() => _EventsGridState();
}

class _EventsGridState extends State<EventsGrid> {
  List<EventType>? types;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      var model = await Dependencies.services.event.eventsType(false);
      if (model != null) {
        await Dependencies.logics.settings.updateEvents(model);
        await Dependencies.logics.patientsSettings.updateEvents(model);
        EventSettings settings;
        if (widget.person == null) {
          settings = Dependencies.logics.settings.getEvents();
        } else {
          settings = Dependencies.logics.patientsSettings.getEvents(
            widget.person,
          );
        }

        // filter using the user settings
        List<EventType> filtered = [];
        for (var item in model) {
          OrderedItem? setting = settings.displaySettings.firstWhereOrNull(
            (element) => element.id == item.id,
          );

          if (setting == null || setting.visible == true) filtered.add(item);
        }

        setState(() {
          types = filtered;
        });
      }
    } catch (ex) {
      Notify.showError("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return types == null
        ? const HelseLoader()
        : BlocListener<SettingsBloc<bool>, bool>(
            listener: (context, state) {
              _getData();
            },
            bloc: Dependencies.logics.settings.events,
            child: Align(
              alignment: AlignmentGeometry.topLeft,
              child: Wrap(
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                spacing: 24,
                runSpacing: 16,
                children:
                    types?.map((type) {
                      var color = Dependencies.theme.stateColor(
                        "${type.id}",
                        StateType.events,
                        context,
                      );
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: color, width: 2),
                          ),
                        ),
                        child: EventWidget(
                          type,
                          widget.date,
                          key: Key(type.id.toString()),
                          person: widget.person,
                        ),
                      );
                    }).toList() ??
                    [],
              ),
            ),
          );
  }
}
