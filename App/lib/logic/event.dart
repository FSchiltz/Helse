import 'package:file_selector/file_selector.dart';

enum SubmissionStatus { initial, success, failure, inProgress }

sealed class ChangedEvent<T> {
  const ChangedEvent(this.value, this.field);

  final String field;
  final T? value;
}

final class FileChangedEvent extends ChangedEvent<XFile> {
  const FileChangedEvent(XFile value, String field) : super(value, field);
}

final class TextChangedEvent extends ChangedEvent<String> {
  const TextChangedEvent(String value, String field) : super(value, field);
}

final class IntChangedEvent extends ChangedEvent<int> {
  const IntChangedEvent(int value, String field) : super(value, field);
}

final class BoolChangedEvent extends ChangedEvent<bool> {
  const BoolChangedEvent(bool value, String field) : super(value, field);
}

final class DateChangedEvent extends ChangedEvent<DateTime> {
  const DateChangedEvent(DateTime value, String field) : super(value, field);
}

final class SubmittedEvent extends ChangedEvent {
  final void Function()? callback;

  const SubmittedEvent(String field, {this.callback}) : super(null, field);
}
