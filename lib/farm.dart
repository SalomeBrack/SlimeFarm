import 'package:flutter/material.dart';

class FarmView extends StatefulWidget {
  FarmView({Key? key}) : super(key: key);

  @override
  _FarmViewState createState() => _FarmViewState();
}

class _FarmViewState extends State<FarmView> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have this many brooders:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Buy new brooder',
        child: Icon(Icons.add),
      ),
    );
  }
}
