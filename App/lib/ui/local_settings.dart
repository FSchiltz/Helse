import 'package:flutter/material.dart';
import 'package:helse/logic/settings/events_settings.dart';
import 'package:helse/logic/settings/health_settings.dart';
import 'package:helse/logic/settings/metrics_settings.dart';
import 'package:helse/logic/settings/ordered_item.dart';
import 'package:helse/logic/settings/theme_settings.dart';
import 'package:helse/main.dart';
import 'package:helse/ui/theme/ordered_list.dart';
import 'package:helse/ui/theme/square_outline_input_border.dart';

import '../logic/settings/settings_logic.dart';
import 'theme/loader.dart';
import 'theme/notification.dart';

class LocalSettingsPage extends StatefulWidget {
  const LocalSettingsPage({super.key});

  @override
  State<LocalSettingsPage> createState() => _LocalSettingsPageState();
}

class _LocalSettingsPageState extends State<LocalSettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _healthEnabled = false;
  ThemeMode _theme = ThemeMode.system;
  List<OrderedItem> _metrics = [];
  List<OrderedItem> _events = [];

  Future<int> _getData() async {
    _healthEnabled = (await SettingsLogic.getHealth()).syncHealth;
    _theme = (await SettingsLogic.getTheme()).theme;
    _metrics = (await SettingsLogic.getMetrics()).metrics;
    _events = (await SettingsLogic.getEvents()).events;

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Local Settings',
            style: Theme.of(context).textTheme.displaySmall),
      ),
      body: FutureBuilder(
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
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...general(theme),
                        //const SizedBox(height: 20),
                        //...syncHealth(theme),
                        const SizedBox(height: 20),
                        ...metrics(theme),
                        const SizedBox(height: 20),
                        ...events(theme),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: const ContinuousRectangleBorder(),
                            ),
                            onPressed: _submit,
                            child: const Text("Save"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
            return const Center(
                child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }

  void _submit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user's settings
        await SettingsLogic.saveHealth(HealthSettings(_healthEnabled));
        await SettingsLogic.saveTheme(ThemeSettings(_theme));
        await SettingsLogic.saveEvents(EventsSettings(_events));
        await SettingsLogic.saveMetrics(MetricsSettings(_metrics));

        Notify.show("Saved Successfully");
        _getData();
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  List<Widget> syncHealth(ColorScheme theme) {
    return [
      Text("Sync Health", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 5),
      Flexible(
        child: Row(
          children: [
            const Text("Enable"),
            Switch(
                value: _healthEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _healthEnabled = value!;
                  });
                  _submit();
                })
          ],
        ),
      ),
    ];
  }

  List<Widget> metrics(ColorScheme theme) {
    return [
      Text("Metrics", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 20),
      OrderedList(_metrics),
    ];
  }

  List<Widget> events(ColorScheme theme) {
    return [
      Text("Events", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 20),
      OrderedList(_events),
    ];
  }

  List<Widget> general(ColorScheme theme) {
    return [
      Text("General", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 20),
      SizedBox(
        width: 200,
        child: DropdownButtonFormField(
          value: _theme,
          onChanged: themeCallback,
          items: ThemeMode.values
              .map((type) =>
                  DropdownMenuItem(value: type, child: Text(type.name)))
              .toList(),
          decoration: InputDecoration(
            labelText: 'Theme',
            prefixIcon: const Icon(Icons.list_sharp),
            prefixIconColor: theme.primary,
            filled: true,
            fillColor: theme.surface,
            border: SquareOutlineInputBorder(theme.primary),
          ),
        ),
      )
    ];
  }

  void themeCallback(ThemeMode? value) {
    if (value == null) return;
    // save the settings
    _theme = value;
    _submit();

    // apply the theme
    AppView.of(context).changeTheme(value);
  }
}
