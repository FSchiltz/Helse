import 'package:flutter/material.dart';

class SquareOutlineInputBorder extends OutlineInputBorder {
  SquareOutlineInputBorder(Color color)
      : super(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: color),
        );
}
