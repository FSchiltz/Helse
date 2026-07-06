import 'package:flutter/material.dart';
import 'package:helse/ui/common/inputs/files/file_list_widget.dart';

class FileItem extends StatelessWidget {
  const FileItem({
    super.key,
    required this.file,
    required this.onDelete,
    required this.onTap,
    this.selected = false,
  });

  final bool selected;
  final UIFile file;
  final void Function()? onDelete;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      dense: true,
      leading: const Icon(Icons.insert_drive_file),
      title: Text(file.name),
      onTap: (file.id == null) ? null : () => onTap(),
      trailing: (onDelete == null)
          ? null
          : IconButton(icon: const Icon(Icons.close), onPressed: onDelete),
    );
  }
}
