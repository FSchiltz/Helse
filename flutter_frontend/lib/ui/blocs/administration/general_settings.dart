import 'package:flutter/material.dart';
import 'package:helse/helpers/translation.dart';
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
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              Translation.locale(context).generalSettings,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          const TabBar(
            isScrollable: true,
            dividerHeight: 4,
            labelPadding: EdgeInsetsGeometry.directional(start: 32, end: 32),
            tabs: [
              Tab(icon: Icon(Icons.vpn_lock), text: 'Proxy'),
              Tab(icon: Icon(Icons.lock_open), text: 'OAuth'),
              Tab(icon: Icon(Icons.email), text: 'SMTP'),
              Tab(icon: Icon(Icons.notifications), text: 'Gotify'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: const ProxyView(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: const OauthView(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: const SmtpView(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: const GotifyView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
