import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/notification.dart';

import '../../../../main.dart';
import '../../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../loader.dart';

class OauthView extends StatefulWidget {
  const OauthView({super.key});

  @override
  State<OauthView> createState() => _OauthViewState();
}

class _OauthViewState extends State<OauthView> {
  Oauth? _settings;
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

  Future<Oauth?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_settings != null) return _settings;

    _settings = await DI.settings?.api().oauth();

    _controllerId.text = _settings?.clientId ?? "";
    _controllerSecret.text = _settings?.clientSecret ?? "";

    _enabled = _settings?.enabled ?? false;
    _autoregister = _settings?.autoRegister ?? false;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        fillColor: theme.surface,
                        border: OutlineInputBorder(
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
                        fillColor: theme.surface,
                        border: OutlineInputBorder(
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
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: const ContinuousRectangleBorder(),
                      ),
                      onPressed: submit,
                      child: const Text("Save"),
                    ),
                  ],
                ),
              );
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }

  void submit() async {
    var localContext = context;
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user
        await DI.settings?.api().updateOauth(
              Oauth(
                clientId: _controllerId.text,
                clientSecret: _controllerSecret.text,
                enabled: _enabled,
                autoRegister: _autoregister,
              ),
            );

        if (localContext.mounted) {
          SuccessSnackBar.show("Saved Successfully", localContext);
        }

        _resetSettings();
      }
    } catch (ex) {
      if (localContext.mounted) {
        ErrorSnackBar.show("Error: $ex", localContext);
      }
    }
  }
}
