import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/custom_switch.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/square_text_field.dart';

class ProxyView extends StatelessWidget {
  const ProxyView({super.key});

  Future<Proxy> _getData(bool refresh) async {
    return await Dependencies.services.settings.proxy();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return ProxyFormView(data, callback: reset);
      },
    );
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
          Text(
            "Proxy Authentification",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
          Text(
            "Only enable if you are behind a trusted proxy",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Text("Enabled"),
              CustomSwitch(
                value: _proxyAuth,
                onChanged: (bool? value) {
                  setState(() {
                    _proxyAuth = value!;
                  });
                },
              ),
            ],
          ),
          if (_proxyAuth) ..._fields(theme),
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
        await Dependencies.services.settings.updateProxy(
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

  List<Widget> _fields(ColorScheme theme) {
    return [
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
            },
          ),
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
    ];
  }
}
