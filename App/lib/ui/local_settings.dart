import 'package:flutter/material.dart';
import 'package:helse/main.dart';

import '../logic/settings_logic.dart';
import 'blocs/loader.dart';

class LocalSettingsPage extends StatefulWidget {
  const LocalSettingsPage({super.key});

  @override
  State<LocalSettingsPage> createState() => _LocalSettingsPageState();
}

class _LocalSettingsPageState extends State<LocalSettingsPage> {
  LocalSettings? _settings;
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _healthEnabled = false;

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

    _settings = await AppState.settingsLogic?.getLocalSettings();

    _healthEnabled = _settings?.syncHealth ?? false;

    return _settings;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
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
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Text("Settings", style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 20),
                        ...proxy(theme),
                      ],
                    ),
                  ),
                );
              }
            }
            return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
          }),
    );
  }

  void submit() async {
    var localContext = context;
    if (_formKey.currentState?.validate() ?? false) {
      // save the user
      await AppState.settingsLogic?.saveLocal(LocalSettings(_healthEnabled));

      if (localContext.mounted) {
        ScaffoldMessenger.of(localContext).showSnackBar(
          SnackBar(
            width: 200,
            backgroundColor: Theme.of(localContext).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            content: const Text("Saved Successfully"),
          ),
        );
      }

      _resetSettings();
    }
  }

  proxy(ColorScheme theme) {
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
}
