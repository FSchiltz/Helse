import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import '../../../common/inputs/square_text_field.dart';

class GotifyView extends StatelessWidget {
  const GotifyView({super.key});

  Future<Gotify> _getData(bool reset) async {
    return await Dependencies.services.settings.gotify();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return GotifyFormView(data, callback: reset);
      },
    );
  }
}

class GotifyFormView extends StatefulWidget {
  final Gotify data;
  final void Function() callback;

  const GotifyFormView(this.data, {super.key, required this.callback});

  @override
  State<GotifyFormView> createState() => _SmtpFormViewState();
}

class _SmtpFormViewState extends State<GotifyFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controllerUrl = TextEditingController();
  final TextEditingController _controllerToken = TextEditingController();
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controllerUrl.text = widget.data.url ?? '';
    _controllerToken.text = widget.data.token ?? '';
    _enabled = widget.data.enabled ?? false;
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
          Text('Gotify', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 32),
          Row(
            children: [
              Text(locale.enable),
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
            child: SquareButton(locale.save, () => submit(locale)),
          ),
        ],
      ),
    );
  }

  void submit(AppLocalizations locale) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        final smtp = Gotify(
          url: _controllerUrl.text,
          token: _controllerToken.text,
          enabled: _enabled,
        );

        await Dependencies.services.settings.updateGotify(smtp);

        Notify.show(locale.saved);
        widget.callback();
      }
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }

  List<Widget> _fields(ColorScheme theme) {
    return [
      const SizedBox(height: 10),
      SizedBox(
        width: 400,
        child: SquareTextField(
          controller: _controllerUrl,
          label: 'host',
          icon: Icons.mail_sharp,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'host is required';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: 400,
        child: SquareTextField(
          controller: _controllerToken,
          label: 'Token',
          icon: Icons.password_sharp,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Token is required';
            }
            return null;
          },
        ),
      ),
    ];
  }
}
