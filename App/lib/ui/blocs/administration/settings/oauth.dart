import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../../common/custom_switch.dart';
import '../../../common/square_text_field.dart';
import '../../../common/loader.dart';

class OauthView extends StatefulWidget {
  const OauthView({super.key});

  @override
  State<OauthView> createState() => _OauthViewState();
}

class _OauthViewState extends State<OauthView> {
  Oauth? _settings;

  void _resetSettings() {
    setState(() {
      _settings = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<Oauth?> _getData(bool reset) async {
    _settings = await DI.settings.api().oauth();
    return _settings;
  }

  @override
  Widget build(BuildContext context) {
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
              return OauthFormView(snapshot.data, callback: _resetSettings);
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }
}

class OauthFormView extends StatefulWidget {
  final Oauth? data;
  final void Function() callback;

  const OauthFormView(this.data, {super.key, required this.callback});

  @override
  State<OauthFormView> createState() => _OauthFormViewState();
}

class _OauthFormViewState extends State<OauthFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _controllerId = TextEditingController();
  final TextEditingController _controllerSecret = TextEditingController();
  final TextEditingController _controllerAuth = TextEditingController();
  final TextEditingController _controllerToken = TextEditingController();
  bool _enabled = false;
  bool _autoregister = false;
  bool _autoLogin = false;

  @override
  void initState() {
    super.initState();
    var data = widget.data;
    _controllerId.text = data?.clientId ?? "";
    _controllerSecret.text = data?.clientSecret ?? "";
    _controllerAuth.text = data?.url ?? "";
    _controllerToken.text = data?.tokenurl ?? "";

    _enabled = data?.enabled ?? false;
    _autoregister = data?.autoRegister ?? false;
    _autoLogin = data?.autoLogin ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

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
              CustomSwitch(
                  value: _enabled,
                  onChanged: (bool? value) {
                    setState(() {
                      _enabled = value!;
                    });
                  })
            ],
          ),
          const SizedBox(height: 5),
          SquareTextField(
            controller: _controllerId,
            label: "Client id",
            icon: Icons.person_sharp,
            theme: theme,
          ),
          const SizedBox(height: 10),
          SquareTextField(
            theme: theme,
            controller: _controllerSecret,
            label: "Client secret",
            icon: Icons.password_sharp,
          ),
          const SizedBox(height: 10),
          SquareTextField(
            controller: _controllerAuth,
            label: "Auth url",
            icon: Icons.connect_without_contact_sharp,
            theme: theme,
          ),
          const SizedBox(height: 10),
          SquareTextField(
            controller: _controllerToken,
            label: "Token url",
            icon: Icons.token_sharp,
            theme: theme,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text("Auto register"),
              CustomSwitch(
                  value: _autoregister,
                  onChanged: (bool? value) {
                    setState(() {
                      _autoregister = value!;
                    });
                  })
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text("Auto login"),
              CustomSwitch(
                  value: _autoLogin,
                  onChanged: (bool? value) {
                    setState(() {
                      _autoLogin = value!;
                    });
                  })
            ],
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
        await DI.settings.api().updateOauth(
              Oauth(
                clientId: _controllerId.text,
                clientSecret: _controllerSecret.text,
                enabled: _enabled,
                autoRegister: _autoregister,
                autoLogin: _autoLogin,
                tokenurl: _controllerToken.text,
                url: _controllerAuth.text,
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
