enum MetricTypes {
  none(0),
  heart(1),
  oxygen(2),
  weight(3),
  height(4),
  temperature(5),
  steps(6),
  calories(7),
  distance(8),
  pain(10),
  mood(11),
  medication(12),
  tests(13),
  sex(14),
  stool(15),
  spotting(16),
  headDiameter(17),
  diaper(18);

  final int? value;

  const MetricTypes(this.value);
}
