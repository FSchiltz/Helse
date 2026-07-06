import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/ui_constants.dart';

class MetricFileList extends StatefulWidget {
  final int? person;
  final int? metric;
  final void Function(Set<int>)? onDelete;
  final void Function(List<UIFile>)? onAdd;
  final bool readonly;

  const MetricFileList({
    super.key,
    this.person,
    this.metric,
    this.onDelete,
    this.onAdd,
    this.readonly = false,
  });

  @override
  State<MetricFileList> createState() => _MetricFileListState();
}

class _MetricFileListState extends State<MetricFileList> {
  List<UIFile>? _files;
  final Set<int> _toDelete = {};

  Future<void> _getFileList() async {
    final edit = widget.metric;
    if (edit != null) {
      final result = await Dependencies.services.files.getMetricFiles(
        edit,
        widget.person,
      );

      final xfiles = result
          .map((e) => UIFile(null, e.name, e.id, e.description))
          .toList();

      setState(() {
        _files = xfiles;
      });
    } else {
      setState(() {
        _files = [];
      });
    }
  }

  @override
  void initState() {
    _getFileList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: UIConstants.formPad),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: (_files == null)
          ? HelseLoader()
          : FileListWidget(
              readonly: widget.readonly,
              files: _files!,
              onAdd: (_, x) {
                setState(() {
                  _files = x;
                });
                widget.onAdd?.call(_files!);
              },
              person: widget.person,
              onTap: (x) {
                if (x.id != null) {
                  Dependencies.logics.files.download(
                    x.id!,
                    x.name,
                    widget.person,
                  );
                }
              },
              onDelete: (deleted, x) {
                if (deleted.id != null && !_toDelete.contains(deleted.id)) {
                  _toDelete.add(deleted.id!);
                }

                setState(() {
                  _files = x;
                });

                widget.onDelete?.call(_toDelete);
              },
            ),
    );
  }
}
