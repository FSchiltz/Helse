import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/loading_builder.dart';

class ConstantsSettings extends StatelessWidget {
  const ConstantsSettings({super.key});

  Future<List<Unit>> _getData(bool reset) async {
    return await Dependencies.services.common.getUnits();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.locale(context);
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Unit Types",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  columns: [
                    DataColumn(label: Expanded(child: Text(locale.id))),
                    DataColumn(label: Expanded(child: Text(locale.code))),
                    DataColumn(
                      label: Expanded(child: Text(locale.description)),
                    ),
                    DataColumn(label: Expanded(child: Text(locale.type))),
                    DataColumn(label: Expanded(child: Text("Base unit"))),
                  ],
                  rows: data
                      .map(
                        (type) => DataRow(
                          cells: [
                            DataCell(Text((type.id).toString())),
                            DataCell(Text(type.code)),
                            DataCell(Text(type.description ?? "")),
                            DataCell(Text(type.type.name)),
                            DataCell(Text(type.baseUnit?.toString() ?? '')),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
