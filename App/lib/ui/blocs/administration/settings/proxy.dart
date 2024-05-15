import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/custom_switch.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../../common/square_text_field.dart';
import '../../../common/loader.dart';

class ProxyView extends StatefulWidget {
  const ProxyView({super.key});

  @override
  State<ProxyView> createState() => _ProxyViewState();
}

class _ProxyViewState extends State<ProxyView> {
  Proxy? _settings;

  void _resetSettings() {
    setState(() {
      _settings = null;
    });
  }

  Future<Proxy?> _getData() async {
    _settings = await DI.settings.api().proxy();

    return _settings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
              return ProxyFormView(snapshot.data, callback: _resetSettings);
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }
}

class ProxyFormView extends StatefulWidget {
  final Proxy? data;
  final void Function() callback;
  const ProxyFormView(this.data, {super.key, required this.callback});

  @override
  State<ProxyFormView> createState() => _ProxyFormViewState();
}

class _ProxyFormViewState extends State<ProxyFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _proxyAuth = false;
  bool _proxyAutoRegister = false;
  final TextEditingController _controllerHeader = TextEditingController();

  @override
  void initState() {
    super.initState();

    _proxyAuth = widget.data?.proxyAuth ?? false;
    _controllerHeader.text = widget.data?.header ?? '';
    _proxyAutoRegister = widget.data?.autoRegister ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Proxy", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text("Proxy auth"),
              CustomSwitch(
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
              CustomSwitch(
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

  void submit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the user
        await DI.settings.api().updateProxy(
              Proxy(
                autoRegister: _proxyAutoRegister,
                proxyAuth: _proxyAuth,
                header: _controllerHeader.text,
              ),
            );

        Notify.show("Saved Successfully");

        widget.callback();
      }
    } catch (ex) {
      Notify.showError("$ex");
    }
  }
}
