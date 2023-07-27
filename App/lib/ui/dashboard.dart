import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<MetricType> types = [];
  DateTime date = DateTime.now();

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

  void _setDate(DateTime value) {
    setState(() {
      date = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var filterDate = date;
    return Scaffold(
        appBar: AppBar(
          title: Text('Metrics', style: Theme.of(context).textTheme.displayMedium),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: _DateInput(_setDate, date),
            ),
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
                          return MetricImport(types);
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
                      var type = types[index];
                      return MetricWidget(type, filterDate, key: Key(type.id?.toString() ?? ""));
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

class _DateInput extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final void Function(DateTime date) _setDateCallback;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final DateTime initial;

  _DateInput(void Function(DateTime date) setDate, this.initial) : _setDateCallback = setDate {
    _displayDate(initial);
  }

  void _displayDate(DateTime date) {
    final String formatted = formatter.format(date);
    _textController.text = formatted;
  }

  Future<void> _setDate(BuildContext context, DateTime initial) async {
    var date = await _pick(context, initial);
    if (date != null) {
      _displayDate(date);
      _setDateCallback(date);
    }
  }

  Future<DateTime?> _pick(BuildContext context, DateTime initial) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: initial, //get today's date
        firstDate: DateTime(1000),
        lastDate: DateTime(3000));
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 40,
      child: TextField(
        controller: _textController,
        onTap: () {
          _setDate(context, initial);
        },
        decoration: InputDecoration(
          labelText: 'date',
          prefixIcon: const Icon(Icons.edit_calendar_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
