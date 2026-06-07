import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/blocs/administration/users/users.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Translation.of(context).userSettings,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          const UsersView(),
        ],
      ),
    );
  }
}
