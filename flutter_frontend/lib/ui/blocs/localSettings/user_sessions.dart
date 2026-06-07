import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/common_card.dart';
import 'package:helse/ui/common/loading_builder.dart';

class UserSessions extends StatelessWidget {
  const UserSessions({super.key});

  Future<List<Session>> _getData(bool refresh) async {
    return await Dependencies.services.user.getSessions();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(locale.sessions, style: theme.textTheme.displaySmall),
        ),
      ),
      body: SafeArea(
        child: LoadingBuilder(
          _getData,
          builder: (context, data, reset) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '${data.length} sessions',
                          style: theme.textTheme.headlineLarge,
                        ),
                        Spacer(),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              shape: const ContinuousRectangleBorder(),
                            ),
                            onPressed: () async {
                              await Dependencies.services.user.logout(true);
                              await Dependencies.logics.authentication
                                  .logOutLocal();
                            },
                            child: Text(locale.cleanSessions),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var session = data[index];
                          var isActive = session.stop?.isAfter(DateTime.now());
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
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
