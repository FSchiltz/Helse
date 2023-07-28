import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/date.dart';
import '../main.dart';
import '../services/swagger_generated_code/swagger.swagger.dart';
import 'blocs/imports/file_import.dart';
import 'blocs/metrics/metric_add.dart';
import 'blocs/metrics/metrics_grid.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<MetricType> types = [];
  DateTimeRange date = DateHelper.now();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var model = await AppState.metricsLogic?.getType();
    if (model != null) {
      setState(() {
        types = model;
      });
    }
  }

  void _setDate(DateTimeRange value) {
    setState(() {
      date = value;
    });
  }

  void _reset() {
    setState(() {
      date = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome', style: Theme.of(context).textTheme.displayMedium),
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
                          return MetricAdd(types, _reset);
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
                        return const FileImport();
                      });
                },
                child: const Icon(
                  Icons.upload_file,
                  size: 32.0,
                ),
              )),
        ],
      ),
      body: MetricsGrid(types: types, date: date),
    );
  }
}

class _DateInput extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();
  final void Function(DateTimeRange date) _setDateCallback;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final DateTimeRange initial;

  _DateInput(void Function(DateTimeRange date) setDate, this.initial) : _setDateCallback = setDate {
    _displayDate(initial);
  }

  void _displayDate(DateTimeRange date) {
    _textController.text = "${formatter.format(date.start)} - ${formatter.format(date.end)}";
  }

  Future<void> _setDate(BuildContext context, DateTimeRange initial) async {
    var date = await _pick(context, initial);
    if (date != null) {
      _displayDate(date);
      _setDateCallback(date);
    }
  }

  Future<DateTimeRange?> _pick(BuildContext context, DateTimeRange initial) async {
    var selectedDate = await showDateRangePicker(
        context: context,
        initialDateRange: initial, //get today's date
        firstDate: DateTime(1000),
        lastDate: DateTime(3000));
    if (selectedDate == null) return null;

    var start = selectedDate.start;
    var end = selectedDate.end;

    return DateTimeRange(start: start, end: DateTime(end.year, end.month, end.day, 23, 59, 59));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 50,
      child: TextField(
        controller: _textController,
        onTap: () {
          _setDate(context, initial);
        },
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
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
