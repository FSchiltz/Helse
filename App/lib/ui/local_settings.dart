import 'package:flutter/material.dart';
import 'package:helse/main.dart';

import '../logic/settings_logic.dart';
import 'blocs/loader.dart';
import 'blocs/notification.dart';

class LocalSettingsPage extends StatefulWidget {
  const LocalSettingsPage({super.key});

  @override
  State<LocalSettingsPage> createState() => _LocalSettingsPageState();
}

class _LocalSettingsPageState extends State<LocalSettingsPage> {
  LocalSettings? _settings;
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _healthEnabled = false;
  ThemeMode _theme = ThemeMode.system;

  void _resetSettings() {
    setState(() {
      _settings = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<LocalSettings?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_settings != null) return _settings;

    _settings = await DI.settings?.getLocalSettings();

    _healthEnabled = _settings?.syncHealth ?? false;
    _theme = _settings?.theme ?? ThemeMode.system;

    return _settings;
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
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...general(theme),
                        const SizedBox(height: 20),
                        //...syncHealth(theme),
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

  void submit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user
        await DI.settings?.saveLocal(LocalSettings(_healthEnabled, _theme));

        Notify.show("Saved Successfully");
        _resetSettings();
      }
    } catch (ex) {
      Notify.showError("Error: $ex");
    }
  }

  syncHealth(ColorScheme theme) {
    return [
      Text("Sync Health", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Enable"),
          Switch(
              value: _healthEnabled,
              onChanged: (bool? value) {
                setState(() {
                  _healthEnabled = value!;
                });
                submit();
              })
        ],
      ),
    ];
  }

  general(ColorScheme theme) {
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primary),
            ),
          ),
        ),
      )
    ];
  }

  void themeCallback(ThemeMode? value) {
    if (value == null) return;
    // save the settings
    _theme = value;
    submit();

    // apply the theme
    AppView.of(context).changeTheme(value);
  }
}
