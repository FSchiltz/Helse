import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../loader.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Settings? _settings;
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _controllerId = TextEditingController();
  final TextEditingController _controllerSecret = TextEditingController();
  bool _enabled = false;
  bool _autoregister = false;

  void _resetSettings() {
    setState(() {
      _settings = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<Settings?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_settings != null) return _settings;

    _settings = await AppState.settingsLogic?.getSettings();

    _controllerId.text = _settings?.oauth?.clientId ?? "";
    _controllerSecret.text = _settings?.oauth?.clientSecret ?? "";

    _enabled = _settings?.oauth?.enabled ?? false;
    _autoregister = _settings?.oauth?.autoRegister ?? false;
    return _settings;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return FutureBuilder(
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
                      ...oauth(theme),
                      const SizedBox(height: 20),
                      ...proxy(theme),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: submit,
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }

  void submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // save the user
      await AppState.settingsLogic?.save(Settings(
          oauth: Oauth(
        clientId: _controllerId.text,
        clientSecret: _controllerSecret.text,
        enabled: _enabled,
        autoRegister: _autoregister,
      )));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 200,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text("Saved Successfully"),
        ),
      );

      _resetSettings();
    }
  }

  proxy(ColorScheme theme) {
    return [
      Text("Proxy", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Proxy auth"),
          Switch(
              value: _enabled,
              onChanged: (bool? value) {
                setState(() {
                  _enabled = value!;
                });
              })
        ],
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: _controllerId,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Header name",
          prefixIcon: const Icon(Icons.person_sharp),
          prefixIconColor: theme.primary,
          filled: true,
          fillColor: theme.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.primary),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Auto register"),
          Switch(
              value: _autoregister,
              onChanged: (bool? value) {
                setState(() {
                  _autoregister = value!;
                });
              })
        ],
      )
    ];
  }

  oauth(ColorScheme theme) {
    return [
      Text("Oauth", style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Enabled"),
          Switch(
              value: _enabled,
              onChanged: (bool? value) {
                setState(() {
                  _enabled = value!;
                });
              })
        ],
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: _controllerId,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Client id",
          prefixIcon: const Icon(Icons.person_sharp),
          prefixIconColor: theme.primary,
          filled: true,
          fillColor: theme.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.primary),
          ),
        ),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: _controllerSecret,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Client secret",
          prefixIcon: const Icon(Icons.person_sharp),
          prefixIconColor: theme.primary,
          filled: true,
          fillColor: theme.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.primary),
          ),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          const Text("Auto register"),
          Switch(
              value: _autoregister,
              onChanged: (bool? value) {
                setState(() {
                  _autoregister = value!;
                });
              })
        ],
      )
    ];
  }
}
