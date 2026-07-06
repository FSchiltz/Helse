import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/inputs/file_list_widget.dart';
import 'package:helse/ui/common/loader.dart';

class MetricFileList extends StatefulWidget {
  final int? person;
  final int? metric;
  final void Function(Set<int>)? onDelete;
  final void Function(List<UIFile>)? onAdd;

  const MetricFileList({
    super.key,
    this.person,
    this.metric,
    this.onDelete,
    this.onAdd,
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
    final locale = Translation.of(context);

    return (_files == null)
        ? HelseLoader()
        : FileListWidget(
            files: _files!,
            onAdd: (_, x) {
              setState(() {
                _files = x;
              });
              widget.onAdd?.call(_files!);
            },
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
            label: locale.file,
          );
  }
}
