import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/ui/common/notification.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
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
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
      },
    );
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
  final TextEditingController _controllerClaims = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  bool _enabled = false;
  bool _autoregister = false;
  bool _autoLogin = false;

  @override
  void initState() {
    super.initState();
    var data = widget.data;
    var provider = data?.providers?.firstOrNull;
    _controllerId.text = provider?.clientId ?? "";
    _controllerSecret.text = provider?.clientSecret ?? "";
    _controllerAuth.text = provider?.url ?? "";
    _controllerToken.text = provider?.tokenurl ?? "";
    _controllerClaims.text = provider?.claimsUrl ?? "";
    _enabled = data?.enabled ?? false;
    _autoregister = provider?.autoRegister ?? false;
    _autoLogin = provider?.autoLogin ?? false;
    _controllerName.text = provider?.name ?? "";
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
          const SizedBox(height: 32),
          Row(
            children: [
              const Text("Enabled"),
              CustomSwitch(
                value: _enabled,
                onChanged: (bool? value) {
                  setState(() {
                    _enabled = value!;
                  });
                },
              ),
            ],
          ),
          if (_enabled) ..._fields(theme),
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
        List<OauthProvider> providers = [];
        if (_enabled) {
          providers.add(
            OauthProvider(
              clientId: _controllerId.text,
              clientSecret: _controllerSecret.text,
              autoRegister: _autoregister,
              autoLogin: _autoLogin,
              tokenurl: _controllerToken.text,
              url: _controllerAuth.text,
              claimsUrl: _controllerClaims.text,
              name: _controllerName.text,
            ),
          );
        }
        // save the oauth
        await DI.settings.api().updateOauth(
          Oauth(enabled: _enabled, providers: providers),
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
        controller: _controllerName,
        label: "Name",
        icon: Icons.connect_without_contact,
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
      const SizedBox(height: 10),
      SquareTextField(
        controller: _controllerClaims,
        label: "Claims url",
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
            },
          ),
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
            },
          ),
        ],
      ),
    ];
  }
}
