class TimelineNode<T> {
  final DateTime start;
  final DateTime stop;
  final String label;

  // the item is a list because multiple small and close items can be rendred together
  final List<T> items;

  TimelineNode(this.start, this.stop, this.label, this.items);
}
