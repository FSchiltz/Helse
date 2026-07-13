import 'package:flutter/material.dart';

class SelectionController<T> extends ChangeNotifier {
  List<T> selected = [];

  void clear() {
    selected.clear();
    notifyListeners();
  }

  void select(List<T> selection) {
    selected = selection.toList();
    notifyListeners();
  }
}
