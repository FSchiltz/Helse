sealed class ChangedEvent {
  const ChangedEvent(this.field);

  final String field;
}

final class TextChangedEvent extends ChangedEvent {
  const TextChangedEvent(this.value, String field): super(field);

  final String value;
}

final class IntChangedEvent extends ChangedEvent {
  const IntChangedEvent(this.value, String field): super(field);

  final int value;
}

final class BoolChangedEvent extends ChangedEvent {
  const BoolChangedEvent(this.value, String field): super(field);

  final bool value;
}

final class DateChangedEvent extends ChangedEvent {
  const DateChangedEvent(this.value, String field): super(field);

  final DateTime value;
}

final class SubmittedEvent extends ChangedEvent {
  const SubmittedEvent(String field): super(field);
}