import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/inputs/custom_switch.dart';
import '../../../common/inputs/square_text_field.dart';

class OauthView extends StatelessWidget {
  const OauthView({super.key});

  Future<Oauth> _getData(bool reset) async {
    return await Dependencies.services.settings.oauth();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return OauthFormView(data, callback: reset);
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
    var locale = Translation.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Oauth", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: UIConstants.headerPad),
          HelseSwitch(locale.enable, _enabled, (bool? value) {
            setState(() {
              _enabled = value!;
            });
          }),

          if (_enabled) ..._fields(theme),
          const SizedBox(height: UIConstants.formPad),
          SizedBox(
            width: 200,
            child: SquareButton(locale.save, () => submit(locale)),
          ),
        ],
      ),
    );
  }

  void submit(AppLocalizations locale) async {
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
        await Dependencies.services.settings.updateOauth(
          Oauth(enabled: _enabled, providers: providers),
        );

        Notify.show(locale.saved);

        widget.callback();
      }
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  List<Widget> _fields(ColorScheme theme) {
    return [
      SquareTextField(
        controller: _controllerId,
        label: "Client id",
        icon: Icons.person_sharp,
      ),
      const SizedBox(height: UIConstants.formPad),
      SquareTextField(
        controller: _controllerName,
        label: "Name",
        icon: Icons.connect_without_contact,
      ),
      const SizedBox(height: UIConstants.formPad),
      SquareTextField(
        controller: _controllerSecret,
        label: "Client secret",
        icon: Icons.password_sharp,
      ),
      const SizedBox(height: UIConstants.formPad),
      SquareTextField(
        controller: _controllerAuth,
        label: "Auth url",
        icon: Icons.connect_without_contact_sharp,
      ),
      const SizedBox(height: UIConstants.formPad),
      SquareTextField(
        controller: _controllerToken,
        label: "Token url",
        icon: Icons.token_sharp,
      ),
      const SizedBox(height: UIConstants.formPad),
      SquareTextField(
        controller: _controllerClaims,
        label: "Claims url",
        icon: Icons.token_sharp,
      ),
      const SizedBox(height: UIConstants.formPad),
      HelseSwitch("Auto register", _autoregister, (bool? value) {
        setState(() {
          _autoregister = value!;
        });
      }),
      const SizedBox(height: UIConstants.formPad),
      HelseSwitch("Auto login", _autoLogin, (bool? value) {
        setState(() {
          _autoLogin = value!;
        });
      }),
    ];
  }
}
