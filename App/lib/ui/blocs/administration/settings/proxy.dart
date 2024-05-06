import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/theme/notification.dart';

import '../../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../../theme/square_text_field.dart';
import '../../../theme/loader.dart';

class ProxyView extends StatefulWidget {
  const ProxyView({super.key});

  @override
  State<ProxyView> createState() => _ProxyViewState();
}

class _ProxyViewState extends State<ProxyView> {
  Proxy? _settings;
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _proxyAuth = false;
  bool _proxyAutoRegister = false;
  final TextEditingController _controllerHeader = TextEditingController();

  void _resetSettings() {
    setState(() {
      _settings = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<Proxy?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_settings != null) return _settings;

    _settings = await DI.settings?.api().proxy();

    _controllerHeader.text = _settings?.header ?? "";

    _proxyAuth = _settings?.proxyAuth ?? false;
    _proxyAutoRegister = _settings?.autoRegister ?? false;
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
                    Text("Proxy",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Proxy auth"),
                        Switch(
                            value: _proxyAuth,
                            onChanged: (bool? value) {
                              setState(() {
                                _proxyAuth = value!;
                              });
                            })
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Auto register"),
                        Switch(
                            value: _proxyAutoRegister,
                            onChanged: (bool? value) {
                              setState(() {
                                _proxyAutoRegister = value!;
                              });
                            })
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: SquareTextField(
                        controller: _controllerHeader,
                        label: "Header name",
                        icon: Icons.text_fields_sharp,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: const ContinuousRectangleBorder(),
                        ),
                        onPressed: submit,
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Center(
              child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }

  void submit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user
        await DI.settings?.api().updateProxy(
              Proxy(
                autoRegister: _proxyAutoRegister,
                proxyAuth: _proxyAuth,
                header: _controllerHeader.text,
              ),
            );

        Notify.show("Saved Successfully");

        _resetSettings();
      }
    } catch (ex) {
      Notify.show("Error: $ex");
    }
  }
}
