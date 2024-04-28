import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../services/swagger/generated_code/swagger.swagger.dart';
import '../../loader.dart';
import 'metric_add.dart';

class MetricSettingsView extends StatefulWidget {
  const MetricSettingsView({super.key});

  @override
  State<MetricSettingsView> createState() => _MetricSettingsViewState();
}

class _MetricSettingsViewState extends State<MetricSettingsView> {
  List<MetricType>? _types;

  void _resetMetricType() {
    setState(() {
      _types = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<List<MetricType>?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_types != null) return _types;

    _types = await AppState.metric?.metricsType();
    return _types;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(_dummy),
        builder: (context, snapshot) {
          // Checking if future is resolved
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final types = snapshot.data as List<MetricType>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text("Metric management", style: Theme.of(context).textTheme.displaySmall),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MetricTypeAdd(_resetMetricType);
                                });
                          },
                          icon: const Icon(Icons.add_sharp)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        DataTable(
                          columns: const [
                            DataColumn(
                                label: Expanded(
                              child: Text("Id"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Name"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Description"),
                            )),
                            DataColumn(
                                label: Expanded(
                              child: Text("Unit"),
                            ))
                          ],
                          rows: types
                              .map((user) =>
                                  DataRow(cells: [DataCell(Text((user.id).toString())), DataCell(Text(user.name ?? "")), DataCell(Text(user.description ?? "")), DataCell(Text(user.unit ?? ""))]))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }
}
