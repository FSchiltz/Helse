class TimelineNode<T> {
  final DateTime start;
  final DateTime stop;
  final String label;
  final T item;

  TimelineNode(this.start, this.stop, this.label, this.item);
}
