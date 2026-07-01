import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/custom_switch.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';
import 'package:helse/ui/common/square_button.dart';
import 'package:helse/ui/common/ui_constants.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../../common/inputs/square_text_field.dart';

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
  void dispose() {
    _controllerHeader.dispose();
    super.dispose();
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
          Text(
            "Proxy Authentification",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
          Text(
            "Only enable if you are behind a trusted proxy",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: UIConstants.headerPad),
          HelseSwitch(locale.enable, _proxyAuth, (bool? value) {
            setState(() {
              _proxyAuth = value!;
            });
          }),

          if (_proxyAuth) ..._fields(theme),
          const SizedBox(height: UIConstants.formPad),
          SizedBox(
            width: 200,
            child: SquareButton(locale.save, () => submit(context)),
          ),
        ],
      ),
    );
  }

  void submit(BuildContext context) async {
    final locale = Translation.of(context);
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

        Notify.showIcon(NotificationKind.success);

        widget.callback();
      }
    } catch (ex) {
      Notify.show(
        locale.error(ex.toString()),
        context: context.mounted ? context : null,
        kind: NotificationKind.error,
      );
    }
  }

  List<Widget> _fields(ColorScheme theme) {
    return [
      const SizedBox(height: UIConstants.formPad),
      HelseSwitch("Auto register", _proxyAutoRegister, (bool? value) {
        setState(() {
          _proxyAutoRegister = value!;
        });
      }),
      const SizedBox(height: UIConstants.formPad),
      SizedBox(
        width: 400,
        child: SquareTextField(
          controller: _controllerHeader,
          label: "Header name",
          icon: Icons.text_fields_sharp,
        ),
      ),
    ];
  }
}
