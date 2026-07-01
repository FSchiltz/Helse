import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

class MetricSettingsView extends StatefulWidget {
  const MetricSettingsView({super.key});

  @override
  State<MetricSettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<MetricSettingsView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<int> _getData(bool refresh) async {
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) => Form(
        key: _formKey,
        child: Column(children: [
          ],
        ),
      ),
    );
  }

  void submit(BuildContext context) async {
    final locale = Translation.of(context);
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the settings

        Notify.showIcon(NotificationKind.success);
      }
    } catch (ex) {
      Notify.show(
        locale.error(ex.toString()),

        context: context.mounted ? context : null,
        kind: NotificationKind.error,
      );
    }
  }
}
