import 'package:flutter/material.dart';

Color getColor(int i) {
  switch (i) {
    case 0:
      return Colors.lightGreenAccent;
    case 1:
      return Colors.lightBlueAccent;
    case 2:
      return Colors.pinkAccent;
    default:
      return Colors.lightGreenAccent;
  }
}
