import 'package:flutter/material.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/notification.dart';

class GroupSettingsView extends StatefulWidget {
  const GroupSettingsView({super.key});

  @override
  State<GroupSettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<GroupSettingsView> {
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

  void submit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // save the settings

        Notify.showIcon(NotificationKind.success);
      }
    } catch (ex) {
      Notify.show("Error: $ex", context: context, kind: NotificationKind.error);
    }
  }
}
