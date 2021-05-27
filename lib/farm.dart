import 'package:flutter/material.dart';

class Farm extends StatefulWidget {
  Farm({Key? key}) : super(key: key);

  @override
  _FarmState createState() => _FarmState();
}

class _FarmState extends State<Farm> {
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
