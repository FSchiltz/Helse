import 'package:flutter/material.dart' hide Interval;
import 'package:helse/helpers/date_helper.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/blocs/events/event_information.dart';
import 'package:helse/ui/common/duration_widget.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/ui_constants.dart';

class SessionList extends StatelessWidget {
  const SessionList({
    super.key,
    required this.height,
    required this.sessions,
    required this.color,
    required this.type,
  });

  final EventType type;
  final double height;
  final List<Interval> sessions;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: SizedBox(
        width: 460,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: UIConstants.formPad,
          children: [
            EventInformation(data: sessions, type: type),
            Divider(thickness: 2,),
            SizedBox(height: height, child: _getSessionsList(sessions)),
          ],
        ),
      ),
    );
  }

  Widget _getSessionsList(List<Interval> sessions) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Wrap(
          spacing: UIConstants.textPad,
          runSpacing: UIConstants.textPad,
          children: [
            Text(
              DateHelper.format(session.start, context: context, short: true),
            ),
            Text('-'),
            Text(
              DateHelper.format(session.stop, context: context, short: true),
            ),
            const SizedBox(width: UIConstants.formPad),
            DurationWidget(
              color: color,
              duration: session.stop.difference(session.start),
            ),

            Divider(),
          ],
        );
      },
    );
  }
}
