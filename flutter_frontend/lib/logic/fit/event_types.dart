enum EventTypes {
  none(0),
  sleep(1),
  care(2),
  workout(3),
  bath(4),
  feeding(5);

  final int? value;

  const EventTypes(this.value);
}
