import 'package:flutter/material.dart';

class MoneyNotifier {
  static ValueNotifier<int> balance = ValueNotifier(40);

  void addMoney(int x) {
    balance.value += x;
  }

  void subtractMoney(int x) {
    balance.value -= x;
  }

  void setMoney(int x) {
    balance.value = x;
  }
}
