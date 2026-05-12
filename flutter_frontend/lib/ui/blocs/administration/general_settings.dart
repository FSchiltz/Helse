import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/administration/settings/gotify.dart';
import 'package:helse/ui/blocs/administration/settings/oauth.dart';
import 'package:helse/ui/blocs/administration/settings/proxy.dart';
import 'package:helse/ui/blocs/administration/settings/smtp.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("General Settings", style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 20),
          const ProxyView(),
          const SizedBox(height: 20),
          const OauthView(),
          const SizedBox(height: 20),
          const SmtpView(),
          const SizedBox(height: 20),
          const GotifyView(),
        ],
      ),
    );
  }
}
