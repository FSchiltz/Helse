enum SubmissionStatus {
  // no known state
  unkown,
  // waiting for the state to init
  waiting,
  // the submission is initialized
  initial,
  inProgress,
  success,
  failure,
  skipped,
}

sealed class ChangedEvent<T> {
  const ChangedEvent(this.value, this.field);

  final String field;
  final T? value;
}
