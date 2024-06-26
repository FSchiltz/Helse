enum SubmissionStatus { initial, success, failure, inProgress, waiting, skipped }

sealed class ChangedEvent<T> {
  const ChangedEvent(this.value, this.field);

  final String field;
  final T? value;
}
