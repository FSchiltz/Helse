import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/account.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/layout/square_dialog.dart';
import 'package:helse/ui/common/loading_builder.dart';
import 'package:helse/ui/common/ui_constants.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserSessions extends StatefulWidget {
  const UserSessions({super.key});

  @override
  State<UserSessions> createState() => _UserSessionsState();
}

class _UserSessionsState extends State<UserSessions> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  Key _sessionsKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<List<Session>> _getData(bool refresh) async {
    return await Dependencies.services.user.getSessions();
  }

  String? _getCurrentSessionId() {
    try {
      final refreshToken = Dependencies.logics.authentication.account
          .getToken()
          ?.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) return null;
      return JwtDecoder.decode(refreshToken)['session'] as String?;
    } catch (_) {
      return null;
    }
  }

  DateTime? _getAccessTokenExpiration() {
    try {
      final accessToken = Dependencies.logics.authentication.account
          .getToken()
          ?.accessToken;
      if (accessToken == null || accessToken.isEmpty) return null;
      return JwtDecoder.getExpirationDate(accessToken);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    var theme = Theme.of(context);
    final currentSessionId = _getCurrentSessionId();
    final accessTokenExpiration = _getAccessTokenExpiration();
    return LoadingBuilder(
      key: _sessionsKey,
      _getData,
      builder: (context, data, reset) {
        return Scaffold(
          appBar: AppBar(
            elevation: 10,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(locale.sessions, style: theme.textTheme.displaySmall),
                const SizedBox(width: 12),
                Text(
                  locale.sessionCount(data.length),
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: locale.cleanSessions,
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => SquareDialog(
                      icon: const Icon(Icons.delete_sweep_outlined),
                      title: Text(locale.cleanSessions),
                      content: Text(locale.confirmCleanSessions),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(locale.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(locale.ok),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && context.mounted) {
                    await Dependencies.logics.authentication.logOut(true);
                  }
                },
                icon: const Icon(Icons.delete_sweep_outlined),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(
                  context,
                ).refreshIndicatorSemanticLabel,
                onPressed: () => setState(() => _sessionsKey = UniqueKey()),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: UIConstants.formPad),                 
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var session = data[index];
                          var isCurrent = session.sessionId == currentSessionId;
                          var isActive = session.stop?.isAfter(_now);
                          Color color = isActive == true
                              ? theme.colorScheme.primaryContainer
                              : theme.colorScheme.errorContainer;
                          return CommonCard(
                            color: color,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(session.userAgent ?? ''),
                                    SizedBox(width: 12),
                                    Text(session.ip ?? ''),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(session.start?.toString() ?? ''),
                                    SizedBox(width: 12),
                                    Text(session.stop?.toString() ?? ''),
                                  ],
                                ),
                                if (isCurrent && session.stop != null)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isActive == true
                                                ? locale.timeLeft(
                                                    DateHelper.formatDuration(
                                                      session.stop!.difference(
                                                        _now,
                                                      ),
                                                      locale,
                                                    ),
                                                  )
                                                : locale.timeLeft(
                                                    locale.expired,
                                                  ),
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          if (accessTokenExpiration != null)
                                            Text(
                                              locale.accessTokenExpires(
                                                accessTokenExpiration.isAfter(
                                                      _now,
                                                    )
                                                    ? DateHelper.formatDuration(
                                                        accessTokenExpiration
                                                            .difference(_now),
                                                        locale,
                                                      )
                                                    : locale.expired,
                                              ),
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
