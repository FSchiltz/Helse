import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/custom_switch.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/notification.dart';
import '../../../common/square_text_field.dart';

class SmtpView extends StatefulWidget {
  const SmtpView({super.key});

  @override
  State<SmtpView> createState() => _SmtpViewState();
}

class _SmtpViewState extends State<SmtpView> {
  Smtp? _settings;
  bool _refresh = false;

  void _resetSettings() {
    setState(() {
      _settings = null;
      _refresh = !_refresh;
    });
  }

  Future<Smtp?> _getData(bool reset) async {
    _settings = await DI.settings.api().smtp();
    return _settings;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(_refresh),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else if (snapshot.hasData) {
            return SmtpFormView(snapshot.data!, callback: _resetSettings);
          }
        }
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SMTP', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text('Enable'),
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
        ],
      ),
    );
  }

  List<Widget> _fields(ColorScheme theme) {
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
          label: 'Username',
          icon: Icons.person_sharp,
          theme: theme,
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
        width: 400,
        child: SquareTextField(
          controller: _controllerPassword,
          label: 'Password',
          icon: Icons.password_sharp,
          theme: theme,
          obscureText: true,
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
          child: const Text('Save'),
        ),
      ),
    ];
  }

  void submit() async {
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

        await DI.settings.api().updateSmtp(smtp);

        Notify.show('Saved Successfully');
        widget.callback();
      }
    } catch (ex) {
      Notify.showError('$ex');
    }
  }
}
