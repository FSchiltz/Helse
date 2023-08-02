import 'package:file_selector/file_selector.dart';

enum SubmissionStatus { initial, success, failure, inProgress }

sealed class ChangedEvent<T> {
  const ChangedEvent(this.value, this.field);

  final String field;
  final T? value;
}
