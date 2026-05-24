import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/administration/users/users.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Users Settings",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          const UsersView(),
        ],
      ),
    );
  }
}
