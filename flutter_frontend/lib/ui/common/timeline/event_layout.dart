import 'package:flutter/material.dart';
import 'package:helse/ui/common/timeline/timeline_node.dart';

class EventLayout<T> {
  final TimelineNode<T> event;
  final double left;
  final double right;
  final double centerY;
  final Color color;

  EventLayout({
    required this.event,
    required this.left,
    required this.right,
    required this.centerY,
    required this.color,
  });
}
