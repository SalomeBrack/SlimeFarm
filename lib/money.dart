import 'package:flutter/material.dart';

class MoneyView extends StatefulWidget {
  MoneyView({Key? key}) : super(key: key);

  @override
  MoneyViewState createState() => MoneyViewState();
}

class MoneyViewState extends State<MoneyView> {
  int _counter = 100;

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$_counter €',
      ),
    );
  }
}
