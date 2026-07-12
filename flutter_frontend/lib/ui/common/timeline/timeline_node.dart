class TimelineNode<T> {
  final DateTime start;
  final DateTime stop;
  final String label;
  final T item;

  TimelineNode(this.start, this.stop, this.label, this.item);
}

class GroupedTimelineNode<T> {
  final DateTime start;
  final DateTime stop;
  final String label;

  // the item is a list because multiple small and close items can be rendred together
  final List<T> items;

  GroupedTimelineNode(this.start, this.stop, this.label, this.items);
}
