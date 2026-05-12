import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/custom_switch.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/notification.dart';
import '../../../common/square_text_field.dart';

class GotifyView extends StatefulWidget {
  const GotifyView({super.key});

  @override
  State<GotifyView> createState() => _GotifyViewState();
}

class _GotifyViewState extends State<GotifyView> {
  Gotify? _settings;
  bool _refresh = false;

  void _resetSettings() {
    setState(() {
      _settings = null;
      _refresh = !_refresh;
    });
  }

  Future<Gotify?> _getData(bool reset) async {
    _settings = await DI.settings.api().gotify();
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
            return GotifyFormView(snapshot.data!, callback: _resetSettings);
          }
        }
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gotify', style: Theme.of(context).textTheme.headlineMedium),
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
          if(_enabled)..._fields(theme),          
        ],
      ),
    );
  }

  void submit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        final smtp = Gotify(
          url: _controllerUrl.text,
          token:_controllerToken.text,
          enabled: _enabled,
        );

        await DI.settings.api().updateGotify(smtp);

        Notify.show('Saved Successfully');
        widget.callback();
      }
    } catch (ex) {
      Notify.showError('$ex');
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
              theme: theme,
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
              theme: theme,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Token is required';
                }
                return null;
              },
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
}
