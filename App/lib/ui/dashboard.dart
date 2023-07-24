import 'package:flutter/material.dart';

import '../logic/metrics/metrics_logic.dart';
import '../services/swagger_generated_code/swagger.swagger.dart';
import 'blocs/metrics/metric_add.dart';
import 'blocs/metrics/metric_import.dart';
import 'blocs/metrics/metric_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<MetricType> types = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var model = await MetricsLogic().getType();
    setState(() {
      types = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Metrics', style: Theme.of(context).textTheme.displayMedium),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    if (types.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MetricAdd(types);
                          });
                    }
                  },
                  child: const Icon(
                    Icons.add,
                    size: 32.0,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MetricImport();
                        });
                  },
                  child: const Icon(
                    Icons.upload_file,
                    size: 32.0,
                  ),
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: types.isEmpty
                ? const CircularProgressIndicator()
                : GridView.builder(
                    itemCount: types.length,
                    itemBuilder: (context, index) {
                      return MetricWidget(types[index]);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (MediaQuery.of(context).size.width ~/ 250).toInt(),
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5,
                    ),
                  ),
          ),
        ));
  }
}
