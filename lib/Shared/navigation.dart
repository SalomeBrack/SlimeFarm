import 'package:flutter/material.dart';

class NavigationNotifier {
  static ValueNotifier<int> page = ValueNotifier(0);

  void changePage(int x) {
    page.value = x;
  }
}
