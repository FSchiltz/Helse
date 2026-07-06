import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';
import 'package:helse/ui/common/loader.dart';
import 'package:helse/ui/common/ui_constants.dart';

class EventFileList extends StatefulWidget {
  final int? person;
  final int? event;
  final void Function(List<UIFile>)? onChange;
  final bool readonly;

  const EventFileList({
    super.key,
    this.person,
    this.event,
    this.onChange,
    this.readonly = false,
  });

  @override
  State<EventFileList> createState() => _MetricFileListState();
}

class _MetricFileListState extends State<EventFileList> {
  List<UIFile>? _files;

  Future<void> _getFileList() async {
    final edit = widget.event;
    if (edit != null) {
      final result = await Dependencies.services.files.getEventFiles(
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

    widget.onChange?.call(_files!);
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
                widget.onChange?.call(_files!);
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
                setState(() {
                  _files = x;
                });

                widget.onChange?.call(_files!);
              },
            ),
    );
  }
}
