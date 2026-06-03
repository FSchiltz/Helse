import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        List<OrderedItem> settings;
        if (widget.person == null) {
          await Dependencies.logics.settings.updateEvents(model);
          settings = await Dependencies.logics.settings.getEvents();
        } else {
          await Dependencies.logics.patientsSettings.updateEvents(model);
          settings = await Dependencies.logics.patientsSettings.getEvents();
        }

        // filter using the user settings
        List<EventType> filtered = [];
        for (var item in model) {
          OrderedItem? setting = settings.firstWhereOrNull(
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
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children:
                  types
                      ?.map(
                        (type) => EventWidget(
                          type,
                          widget.date,
                          key: Key(type.id.toString()),
                          person: widget.person,
                        ),
                      )
                      .toList() ??
                  [],
            ),
          );
  }
}
