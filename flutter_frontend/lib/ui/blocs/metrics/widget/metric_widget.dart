import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/metrics/metric_helper.dart';
import 'package:helse/ui/blocs/metrics/metric_add_button.dart';
import 'package:helse/ui/blocs/metrics/detail/metric_detail_page.dart';
import 'package:helse/ui/blocs/metrics/metric_search_button.dart';
import 'package:helse/ui/common/layout/common_card.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'metric_condensed.dart';

class MetricWidget extends StatefulWidget {
  final MetricType type;
  final DateTimeRange date;
  final int? person;
  final OrderedItem settings;
  final int tile;

  const MetricWidget(
    this.type,
    this.settings,
    this.date, {
    super.key,
    this.person,
    required this.tile,
  });

  @override
  State<MetricWidget> createState() => _MetricWidgetState();
}

class _MetricWidgetState extends State<MetricWidget> {
  _MetricWidgetState();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Metric>> _getData(bool refresh) async {
    return await Dependencies.services.metric.metrics(
      widget.type.id,
      widget.date.start,
      widget.date.end,
      person: widget.person,
      tile: widget.tile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: false,
      child: LoadingBuilder(
        _getData,
        builder: (ctx, data, reset) {
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => MetricDetailPage(
                  date: widget.date,
                  type: widget.type,
                  person: widget.person,
                  summary: data,
                  settings: widget.settings.detailGraph ?? GraphKind.text,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 1, right: 1),
              child: Column(
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.type.name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),

                        Row(
                          children: [
                            MetricSearchButton(
                              widget.type,
                              person: widget.person,
                            ),
                            MetricAddButton(
                              widget.type,
                              reset,
                              person: widget.person,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (data.isNotEmpty &&
                      widget.settings.graph != GraphKind.text)
                    Expanded(
                      child: Align(
                        alignment: AlignmentGeometry.topCenter,
                        child: MetricHelper.getTextInfo(
                          data,
                          widget.type,
                          context,
                        ),
                      ),
                    ),

                  Flexible(
                    child: MetricCondensed(
                      data,
                      widget.type,
                      widget.settings,
                      widget.date,
                      tile: widget.tile,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
