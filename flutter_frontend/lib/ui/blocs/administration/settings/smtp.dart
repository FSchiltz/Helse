import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/l10n/app_localizations.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/custom_switch.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import '../../../common/square_text_field.dart';

class SmtpView extends StatelessWidget {
  const SmtpView({super.key});

  Future<Smtp> _getData(bool reset) async {
    return await Dependencies.services.settings.smtp();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return SmtpFormView(data, callback: reset);
      },
    );
  }
}

class SmtpFormView extends StatefulWidget {
  final Smtp data;
  final void Function() callback;

  const SmtpFormView(this.data, {super.key, required this.callback});

  @override
  State<SmtpFormView> createState() => _SmtpFormViewState();
}

class _SmtpFormViewState extends State<SmtpFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controllerHost = TextEditingController();
  final TextEditingController _controllerPort = TextEditingController();
  final TextEditingController _controllerFromEmail = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _enableSsl = true;
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _controllerHost.text = widget.data.smtpHost ?? '';
    _controllerPort.text = widget.data.smtpPort.toString();
    _controllerFromEmail.text = widget.data.fromEmail ?? '';
    _controllerUserName.text = widget.data.userName ?? '';
    _controllerPassword.text = widget.data.password ?? '';
    _enableSsl = widget.data.enableSsl ?? false;
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
          Text('SMTP', style: Theme.of(context).textTheme.headlineMedium),
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
          if (_enabled) ..._fields(theme, locale),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: SquareButton(locale.save, () => submit(locale)),
          ),
        ],
      ),
    );
  }

  List<Widget> _fields(ColorScheme theme, AppLocalizations locale) {
    return [
      const SizedBox(height: 5),
      Row(
        children: [
          const Text('Enable SSL'),
          CustomSwitch(
            value: _enableSsl,
            onChanged: (bool? value) {
              setState(() {
                _enableSsl = value!;
              });
            },
          ),
        ],
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: 400,
        child: SquareTextField(
          controller: _controllerHost,
          label: 'SMTP host',
          icon: Icons.mail_sharp,
          theme: theme,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'SMTP host is required';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          SizedBox(
            width: 150,
            child: SquareTextField(
              controller: _controllerPort,
              label: 'SMTP port',
              icon: Icons.numbers,
              theme: theme,
              type: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Port is required';
                }
                if (int.tryParse(value) == null) {
                  return 'Invalid port';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 250,
            child: SquareTextField(
              controller: _controllerFromEmail,
              label: 'From email',
              icon: Icons.alternate_email_sharp,
              theme: theme,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'From email is required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: 400,
        child: SquareTextField(
          controller: _controllerUserName,
          label: locale.username,
          icon: Icons.person_sharp,
          theme: theme,
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: 400,
        child: SquareTextField(
          controller: _controllerPassword,
          label: locale.password,
          icon: Icons.password_sharp,
          theme: theme,
          obscureText: true,
        ),
      ),
    ];
  }

  void submit(AppLocalizations locale) async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        final smtp = Smtp(
          smtpHost: _controllerHost.text,
          smtpPort: int.tryParse(_controllerPort.text) ?? 587,
          enableSsl: _enableSsl,
          fromEmail: _controllerFromEmail.text,
          userName: _controllerUserName.text.isNotEmpty
              ? _controllerUserName.text
              : null,
          password: _controllerPassword.text.isNotEmpty
              ? _controllerPassword.text
              : null,
          enabled: _enabled,
        );

        await Dependencies.services.settings.updateSmtp(smtp);

        Notify.show(locale.saved);
        widget.callback();
      }
    } catch (ex) {
      Notify.showError(locale.error(ex.toString()));
    }
  }
}
