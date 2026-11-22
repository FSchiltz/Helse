import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/logic/account/server_state.dart';
import 'package:helse/ui/blocs/administration/constants_settings.dart';
import 'package:helse/ui/blocs/administration/event_settings.dart';
import 'package:helse/ui/blocs/administration/general_settings.dart';
import 'package:helse/ui/blocs/administration/group_settings.dart';
import 'package:helse/ui/blocs/administration/metric_settings.dart';
import 'package:helse/ui/blocs/administration/user_settings.dart';
import 'package:helse/ui/common/menu_destination.dart';
import 'package:helse/ui/common/layout/navigation_page.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return BlocBuilder<ServerState, ServerStatus>(
      bloc: Dependencies.blocs.server,
      builder: (context, status) {
        if (status.offline && !status.userInitiatedOffline) {
          return Scaffold(
            appBar: AppBar(title: Text(locale.administration)),
            body: Center(child: Text(locale.administrationOnlineOnly)),
          );
        }

        return NavigationPage(
          locale.administration,
          pages: [
            const GeneralSettings(),
            const UserSettings(),
            const GroupSettings(),
            const MetricSettings(),
            const EventSettings(),
            const ConstantsSettings(),
          ],
          menu: [
            MenuDestination(
              icon: Icon(Icons.settings_sharp),
              selectedIcon: Icon(Icons.settings),
              label: locale.general,
            ),
            MenuDestination(
              icon: Icon(Icons.person_search_sharp),
              selectedIcon: Icon(Icons.person),
              label: locale.users,
            ),
            MenuDestination(
              icon: Icon(Icons.subject),
              selectedIcon: Icon(Icons.subject_outlined),
              label: locale.group,
            ),
            MenuDestination(
              icon: Icon(Icons.post_add_sharp),
              selectedIcon: Icon(Icons.post_add_outlined),
              label: locale.metrics,
            ),
            MenuDestination(
              icon: Icon(Icons.event_repeat_sharp),
              selectedIcon: Icon(Icons.event),
              label: locale.events,
            ),
            MenuDestination(
              icon: Icon(Icons.list_alt_sharp),
              selectedIcon: Icon(Icons.list),
              label: locale.constants,
            ),
          ],
        );
      },
    );
  }
}
