import 'package:flutter/material.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/pagination.dart';

abstract class AsyncDataTable<T> extends StatefulWidget {
  const AsyncDataTable({
    super.key,
    required this.count,
    required this.reset,
    required this.callback,
    this.state = false,
  });
  final bool state; // key to allow refresh even when the count does not change
  final void Function() reset;
  final int count;
  final Future<List<T>> Function(int page, int i) callback;
}

abstract class AsyncDataTableState<U, T extends AsyncDataTable<U>>
    extends State<T> {
  List<U> _items = [];
  int _page = 0;
  List<U> selected = [];
  SubmissionStatus _status = SubmissionStatus.initial;

  @override
  void initState() {
    super.initState();

    search();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count || widget.state != oldWidget.state) {
      _page = 0;
      _items = [];
      search();
    }
  }

  Future<void> search() async {
    setState(() {
      _items = [];
      _status = SubmissionStatus.inProgress;
    });
    try {
      if (widget.count > 0) {
        var events = await widget.callback(_page, 50);

        setState(() {
          _items = events;
          _status = SubmissionStatus.success;
        });
      } else {
        setState(() {
          _items = [];
          _status = SubmissionStatus.initial;
        });
      }
    } catch (_) {
      setState(() {
        _items = [];
        _status = SubmissionStatus.failure;
      });
    }
  }

  Widget buildTable(
    List<DataColumn> columns,
    List<DataRow> Function(List<U>, List<U>, bool) builder,
    List<Widget> menu,
    bool extended,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          child: Pagination(
            count: widget.count,
            pageSize: 50,
            page: _page,
            selected: selected.length,
            callBack: (v) {
              setState(() {
                _page = v;
              });
              search();
            },
            menu: menu,
          ),
        ),
        (_status == SubmissionStatus.inProgress)
            ? HelseLoader(color: Theme.of(context).colorScheme.primary)
            : DataTable(
                showCheckboxColumn: true,
                onSelectAll: (value) {
                  if (value == true) {
                    setState(() {
                      selected = _items.toList();
                    });
                  } else {
                    setState(() {
                      selected = [];
                    });
                  }
                },
                columns: columns,
                rows: builder(_items, selected, extended),
              ),
      ],
    );
  }
}
